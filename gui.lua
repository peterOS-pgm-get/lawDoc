local PAGE_WIDTH = 25

local gui = {
    log = pos.Logger('lawDoc.log')
}

gui.window = pos.gui.Window('Law Doc')
gui.window.exitOnHide = true
pos.gui.addWindow(gui.window)

local TYPES = { 'C&D' }

gui.mo_new = pos.gui.MenuOption(1, 'New', TYPES, 8, function(index, option)
    gui.mo_new.visible = false
    gui.loadTemplate(option)
end)
gui.window:addMenuOption(gui.mo_new)

local function loadFile(path, window)
    ---@cast window FileSelector
    gui.log:info('Loading file')
    window:hide()
    local f = fs.open(path, 'r')
    if not f then
        gui.log:error('Unable to open file "'..path..'" for read')
        return
    end
    local file = textutils.unserialiseJSON(f.readAll())
    f.close()
    if not file then
        gui.log:error('File "'..path..'" corrupted')
        return
    end
    gui.loadTemplate(file.template)
    gui.temp.load(file)
end

local function saveFile(path, window)
    ---@cast window FileSelector
    gui.log:info('Saving file')
    window:hide()
    if not string.cont(path,'%.') then
        path = path .. '.ldf'
    end
    local f = fs.open(path, 'w')
    if not f then
        gui.log:error('Unable to open file "'..path..'" for write')
        return
    end
    f.write(textutils.serialiseJSON(gui.temp.getFields()))
    f.close()
end

local function exportFile(path, window)
    ---@cast window FileSelector
    gui.log:info('Exporting file')
    window:hide()
    if not string.cont(path, '.') then
        path = path .. '.txt'
    end
    local f = fs.open(path, 'w')
    if not f then
        gui.log:error('Unable to open file "' .. path .. '" for write')
        return
    end
    f.write(gui.temp.export())
    f.close()
end

gui.fileSel = pos.gui.FileSelector('/home', 'Load', loadFile)

local function splitPages(file)
    local pageSplit = file:split('\\p')
    local pages = {}
    for _, page in pairs(pageSplit) do
        local pageLines = {}
        local lines = page:split('\n')
        for i, line in pairs(lines) do
            if i == #lines and line == '' then
                break
            end
            if #pageLines >= 21 then
                table.insert(pages, pageLines)
                pageLines = {}
            end
            if #line <= 25 then
                table.insert(pageLines, line)
            else
                while #line > 0 do
                    if #pageLines >= 21 then
                        table.insert(pages, pageLines)
                        pageLines = {}
                    end
                    local eI = line:sub(1,25):find(' [^ ]*$') or 25
                    local l = line:sub(1,eI)
                    table.insert(pageLines, l)
                    line = line:sub(eI+1)
                end
            end
        end
        table.insert(pages, pageLines)
    end
    return pages
end

gui.mo_file = pos.gui.MenuOption(6, 'File', {'Load','Save','Export','Print'}, 8, function(index, option)
    gui.mo_file.visible = false
    gui.log:debug(option)
    if option == 'Load' then
        gui.fileSel:setAction('Load', loadFile)
        gui.fileSel:show()
    elseif option == 'Save' then
        gui.fileSel:setAction('Save', saveFile)
        gui.fileSel:show()
    elseif option == 'Export' then
        gui.fileSel:setAction('Export', exportFile)
        gui.fileSel:show()
    elseif option == 'Print' then
        local str = gui.temp.export()
        local printer = peripheral.find('printer')
        if not printer then
            gui.log:error('Unable to find printer peripheral')
            return
        end
        local pages = splitPages(str)
        for pageN, page in pairs(pages) do
            printer.newPage()
            printer.setPageTitle(gui.temp.name .. ' ' .. pageN .. '/' .. #pages)

            for lineN,line in pairs(page) do
                printer.setCursorPos(1, lineN)
                printer.write(line)
            end

            printer.endPage()
        end
    end
end)
gui.window:addMenuOption(gui.mo_file)

gui.body = pos.gui.ScrollField(math.floor((gui.window.w - PAGE_WIDTH - 1) / 2), 2, PAGE_WIDTH - 1, gui.window.h - 1)
-- gui.body.bg = colors.blue
gui.window:addElement(gui.body)

function gui.loadTemplate(template)
    gui.log:info('Loading template: '..tostring(template))
    gui.body:clearElements()
    local good = false
    for _, ty in pairs(TYPES) do
        if ty == template then
            good = true
            break
        end
    end
    if not good then
        gui.log:warn('Tried to open unknown template: "'..tostring(template)..'"')
        return
    end
    local f, e = loadfile('types/' .. template .. '.lua')
    if (not f) or e then
        gui.log:error('Unable to open type: ' .. template)
        return
    end
    gui.temp = f(gui.body)
end

function gui.show(args)
    gui.window:show()

    pos.gui.run()

    pos.gui.removeWindow(gui.window)
end

return gui