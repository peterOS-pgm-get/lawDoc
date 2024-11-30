-- Release of Liability

--[[
    Release of Liability

    _Organization_ ("The Organization")
    _Activity_ ("The Activity")

    I _Name_ hereby assume all risks associated with The Activity.
    I release The Organization from liability in regards to my participation in The Activity.

    I hereby waive my right to seek compensation from The Organization for any injury or property damage resulting from The Activity.

    __Signature__
    Date: _Date_

    Valid Through: _Valid_Through_
]]

local body = unpack({ ... }) ---@type ScrollField

local fieldElements = {} ---@type table<string, TextInput>

local function getFields()
    local fields = { template = 'RoL' }
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

body:addElement(pos.gui.TextBox(1, 2, nil, nil, 'Organization:'))
fieldElements['organization'] = pos.gui.TextInput(2, 3, body.w - 3)

body:addElement(pos.gui.TextBox(1, 5, nil, nil, 'Activity:'))
fieldElements['activity'] = pos.gui.TextInput(2, 6, body.w - 3)
fieldElements['organization'].next = fieldElements['activity']

body:addElement(pos.gui.TextBox(1, 8, nil, nil, 'Signer:'))
fieldElements['name'] = pos.gui.TextInput(2, 9, body.w-3)
fieldElements['activity'].next = fieldElements['name']

body:addElement(pos.gui.TextBox(1, 10, nil, nil, 'Date:'))
fieldElements['date'] = pos.gui.TextInput(7, 10, body.w - 6)
fieldElements['name'].next = fieldElements['date']

body:addElement(pos.gui.TextBox(1, 12, nil, nil, 'Valid Through:'))
fieldElements['valid'] = pos.gui.TextInput(2, 13, body.w - 3)
fieldElements['date'].next = fieldElements['valid']

local function export()
    
    local out = 'Release of Liability\n'
    out = out .. '\n'
    out = out .. ('%s ("The Organization")\n'):format(fieldElements['organization'].text)
    out = out .. ('%s ("The Activity")\n'):format(fieldElements['activity'].text)
    out = out .. '\n'
    out = out .. ('I %s hereby assume all risks associated with The Activity.\n'):format(fieldElements['name'].text)
    out = out .. 'I release The Organization from liability in regards to my participation in The Activity.\n'
    out = out .. '\n'
    out = out .. 'I hereby waive my right to seek compensation from The Organization for any injury or property damage resulting from The Activity.\n'
    out = out .. '\n'
    out = out .. fieldElements['name'].text .. '\n'
    out = out .. ('Date: %s\n'):format(fieldElements['date'].text)
    out = out .. '\n'
    out = out .. ('Valid Through: %s\n'):format(fieldElements['valid'].text)
    return out
end

for _, el in pairs(fieldElements) do
    body:addElement(el)
end

return {
    getFields = getFields,
    load = load,
    export = export,
    name = 'Release of Liability'
}
