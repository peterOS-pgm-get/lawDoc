-- Release of Liability

--[[
    Notice of Intent to Sue
    
    _ATTORNEY_
    _CLIENT_

    _DATE_

    _RECIPIENT_

    Dear _RECIPIENT_,

    Pursuant to _REASON_ you are hereby givin notice that _CLIENT_ intends to commence a lawsuit against you for _AMOUNT_.
    We will file suit if you do not _ACTION_ within _TIME_ after receiving this letter.
    
    Please contact us as soon as possible at _LOCATION_ to resolve this matter.

    The foregoing is not intended to be a complete recitation of all applicable law and/or facts, and shall not be deemed to constitute a waiver or relinquishment of any of _FROM_'s rights or remedies,
    whether legal or equitable, all of which are hereby expressly reserved, including _CLIENT_'s right to all available
    remedies against _RECIPIENT_, including but not limited to the recovery of costs and attorneys’ fees.

    Sincerely,
    _ATTORNEY_
    
]]

local body = unpack({ ... }) ---@type ScrollField

local fieldElements = {} ---@type table<string, TextInput>

local function getFields()
    local fields = { template = 'ItS' }
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

body:addElement(pos.gui.TextBox(1, 2, nil, nil, 'Attorney:'))
fieldElements['attorney'] = pos.gui.TextInput(2, 3, body.w - 3)

body:addElement(pos.gui.TextBox(1, 5, nil, nil, 'Client:'))
fieldElements['client'] = pos.gui.TextInput(2, 6, body.w - 3)
fieldElements['attorney'].next = fieldElements['client']

body:addElement(pos.gui.TextBox(1, 8, nil, nil, 'Date:'))
fieldElements['date'] = pos.gui.TextInput(7, 9, body.w - 6)
fieldElements['client'].next = fieldElements['date']

body:addElement(pos.gui.TextBox(1, 11, nil, nil, 'Recipient:'))
fieldElements['recipient'] = pos.gui.TextInput(2, 12, body.w - 3)
fieldElements['date'].next = fieldElements['recipient']

body:addElement(pos.gui.TextBox(1, 14, nil, nil, 'Reason:'))
fieldElements['reason'] = pos.gui.TextInput(2, 15, body.w - 3)
fieldElements['recipient'].next = fieldElements['reason']

body:addElement(pos.gui.TextBox(1, 17, nil, nil, 'Amount:'))
fieldElements['amount'] = pos.gui.TextInput(2, 18, body.w - 3)
fieldElements['reason'].next = fieldElements['amount']

body:addElement(pos.gui.TextBox(1, 20, nil, nil, 'Action:'))
fieldElements['action'] = pos.gui.TextInput(2, 21, body.w - 3)
fieldElements['amount'].next = fieldElements['action']

body:addElement(pos.gui.TextBox(1, 23, nil, nil, 'Time:'))
fieldElements['time'] = pos.gui.TextInput(2, 24, body.w - 3)
fieldElements['action'].next = fieldElements['time']

body:addElement(pos.gui.TextBox(1, 26, nil, nil, 'Location:'))
fieldElements['location'] = pos.gui.TextInput(2, 27, body.w - 3)
fieldElements['time'].next = fieldElements['location']

local function export()

    local out = 'Notice of Intent to Sue\n'
    out = out .. '\n'
    out = out .. fieldElements['attorney'].text .. '\n'
    out = out .. fieldElements['client'].text .. '\n'
    out = out .. '\n'
    out = out .. fieldElements['date'].text .. '\n'
    out = out .. '\n'
    out = out .. fieldElements['recipient'].text .. '\n'
    out = out .. '\n'
    out = out .. ('Dear %s,\n'):format(fieldElements['recipient'].text)
    out = out .. '\n'
    out = out .. ('Pursuant to %s you are hereby givin notice that %s intends to commence a lawsuit against you for %s.\n'):format(fieldElements['reason'].text, fieldElements['client'].text, fieldElements['amount'].text)
    out = out .. ('We will file suit if you do not %s within %s after receiving this letter.'):format(fieldElements['action'].text, fieldElements['time'].text)
    out = out .. '\n'
    out = out .. ('Please contact us as soon as possible at %s to resolve this matter.'):format(fieldElements['location'].text)
    out = out .. '\n'
    out = out .. ('The foregoing is not intended to be a complete recitation of all applicable law and/or facts, and shall not be deemed to constitute a waiver or relinquishment of any of %s\'s rights or remedies,'):format(fieldElements['client'].text)
    out = out .. ('whether legal or equitable, all of which are hereby expressly reserved, including %s\'s right to all available'):format(fieldElements['client'].text)
    out = out .. ('remedies against %s, including but not limited to the recovery of costs and attorneys’ fees.\n'):format(fieldElements['recipient'].text)
    out = out .. '\n'
    out = out .. 'Sincerely,\n'
    out = out .. fieldElements['attorney'].text
    return out
end

for _, el in pairs(fieldElements) do
    body:addElement(el)
end

return {
    getFields = getFields,
    load = load,
    export = export,
    name = 'Intent to Sue'
}
