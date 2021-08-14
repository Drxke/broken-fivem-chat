RegisterServerEvent('chat:init')
RegisterServerEvent('chat:addTemplate')
RegisterServerEvent('chat:addMessage')
RegisterServerEvent('chat:addSuggestion')
RegisterServerEvent('chat:removeSuggestion')
RegisterServerEvent('_chat:messageEntered')
RegisterServerEvent('chat:clear')
RegisterServerEvent('__cfx_internal:commandFallback')

function DoesPHavePerms(source, lvl)
    local haspermission = false
	if lvl == "admin" then
		if IsPlayerAceAllowed(source, "owner") then
			haspermission = true
		elseif IsPlayerAceAllowed(source, "snradmin") then
			haspermission = true
		elseif IsPlayerAceAllowed(source, "fadmin") then
			haspermission = true
		else
			haspermission = false
		end
	elseif lvl == "gs" then
		if IsPlayerAceAllowed(source, "owner") then
			haspermission = true
		elseif IsPlayerAceAllowed(source, "snradmin") then
			haspermission = true
		elseif IsPlayerAceAllowed(source, "fadmin") then
			haspermission = true
		elseif IsPlayerAceAllowed(source, "GStaff") then
			haspermission = true
		else
			haspermission = false
		end
	else
		haspermission = false
	end
	return haspermission
end

AddEventHandler('_chat:messageEntered', function(author, color, message)
    if not message or not author then
        return
    end

    TriggerEvent('chatMessage', source, author, message)

    if not WasEventCanceled() then
        TriggerClientEvent('chatMessage', -1, author,  { 255, 255, 255 }, message)
    end

    print(author .. ': ' .. message)
end)

AddEventHandler('__cfx_internal:commandFallback', function(command)
    local name = GetPlayerName(source)

    TriggerEvent('chatMessage', source, name, '/' .. command)

    if not WasEventCanceled() then
        TriggerClientEvent('chatMessage', -1, name, { 255, 255, 255 }, '/' .. command) 
    end

    CancelEvent()
end)

-- player join messages
AddEventHandler('playerConnecting', function()
    if DoesPHavePerms(source, "gs") then
        TriggerClientEvent('chatMessage', -1, '' .. GetPlayerName(source) .. ' joined', {145, 145, 145})
    end
end)

AddEventHandler('playerDropped', function(reason)
    if DoesPHavePerms(source, "gs") then
        TriggerClientEvent('chatMessage', -1, '' .. GetPlayerName(source) .. ' left (' .. reason .. ')', {145, 145, 145})
    end
end)

RegisterCommand('say', function(source, args, rawCommand)
	if source == 0 then
		TriggerClientEvent('chatMessage', -1, (source == 0) and '[CONSOLE]' or GetPlayerName(source), { 255, 165, 0 }, rawCommand:sub(5))
	else
		TriggerClientEvent('chatMessage', source, "^*^3You cannot use this command.")
	end
end)