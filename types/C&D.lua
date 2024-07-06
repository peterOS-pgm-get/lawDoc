-- Cease and Desist

local body = unpack({ ... }) ---@type ScrollField

local fieldElements = {} ---@type table<string, TextInput>

local function getFields()
    local fields = { template = 'C&D' }
    for field, input in pairs(fieldElements) do
        fields[field] = input.text
    end
    return fields
end

local function load(fields)
    for field, data in pairs(fields) do
        if fieldElements[field] then
            fieldElements[field]:setText(data)
        end
    end
end

body:addElement(pos.gui.TextBox(1, 2, nil, nil, 'From:'))
body:addElement(pos.gui.TextBox(1, 3, nil, nil, '-'))
fieldElements['from1'] = pos.gui.TextInput(3, 3, body.w-1)
body:addElement(pos.gui.TextBox(1, 4, nil, nil, '-'))
fieldElements['from2'] = pos.gui.TextInput(3, 4, body.w-1)
fieldElements['from1'].next = fieldElements['from2']
body:addElement(pos.gui.TextBox(1, 5, nil, nil, '-'))
fieldElements['from3'] = pos.gui.TextInput(3, 5, body.w-1)
fieldElements['from2'].next = fieldElements['from3']

body:addElement(pos.gui.TextBox(1, 7, nil, nil, 'Date:'))
fieldElements['date'] = pos.gui.TextInput(7, 7, body.w - 5)
fieldElements['from3'].next = fieldElements['date']

body:addElement(pos.gui.TextBox(1, 9, nil, nil, 'To:'))
fieldElements['to'] = pos.gui.TextInput(5, 9, body.w - 3)
fieldElements['date'].next = fieldElements['to']

body:addElement(pos.gui.TextBox(1, 11, nil, nil, 'Reason:'))
local reasonStart = 'This notice is served upon'
body:addElement(pos.gui.TextBox(1, 12, nil, nil, reasonStart))
fieldElements['reason1'] = pos.gui.TextInput(1, 13, body.w+1)
fieldElements['to'].next = fieldElements['reason1']
fieldElements['reason2'] = pos.gui.TextInput(1, 14, body.w + 1)
fieldElements['reason1'].next = fieldElements['reason2']
fieldElements['reason3'] = pos.gui.TextInput(1, 15, body.w+1)
fieldElements['reason2'].next = fieldElements['reason3']

body:addElement(pos.gui.TextBox(1, 17, nil, nil, 'Date 2:'))
fieldElements['date2'] = pos.gui.TextInput(9, 17, body.w - 7)
fieldElements['reason3'].next = fieldElements['date2']

local function export()
    local out = 'Notice to Cease and Desist\n'
    out = out .. '\n'
    out = out .. 'Date: ' .. fieldElements['date'].text .. '\n'
    out = out .. '\n'
    out = out .. 'From:\n'
    out = out .. '- ' .. fieldElements['from1'].text .. '\n'
    if fieldElements['from2'].text ~= '' then out = out .. '- ' .. fieldElements['from2'].text .. '\n' end
    if fieldElements['from3'].text ~= '' then out = out .. '- ' .. fieldElements['from3'].text .. '\n' end
    out = out .. '\n'
    out = out .. 'Dear: ' .. fieldElements['to'].text .. '\n'
    out = out .. '\n'
    out = out .. reasonStart.. ' '
    out = out .. fieldElements['reason1'].text .. ' '
    if fieldElements['reason2'].text ~= '' then out = out .. fieldElements['reason2'].text .. ' ' end
    if fieldElements['reason3'].text ~= '' then out = out .. fieldElements['reason3'].text .. ' ' end
    out = out .. '("Activity")\n'
    out = out .. '\n'
    out = out .. '__If you do not cease the aforementioned Activity a lawsuit will be commenced against you__\n'
    out = out .. '\n'
    out = out .. 'You will not receive another warning letter. If you do not confirm in writing to us by '..fieldElements['date2'].text..' that you will cease violating our Agreement a lawsuit will be commenced immediately\n'
    out = out .. '\n'
    out = out .. 'Sincerely,\n'
    out = out .. fieldElements['from1'].text .. ''
    if fieldElements['from2'].text ~= '' then out = out .. ',\n' .. fieldElements['from2'].text .. '' end
    if fieldElements['from3'].text ~= '' then out = out .. ',\n' .. fieldElements['from3'].text .. '' end
    return out
end

for _, el in pairs(fieldElements) do
    body:addElement(el)
end

return {
    getFields = getFields,
    load = load,
    export = export,
    name = 'Cease and Desist'
}
