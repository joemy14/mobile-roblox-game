local Players = game:GetService("Players")

local function setupCharacter(character)
	local humanoid = character:WaitForChild("Humanoid")
	local hrp = character:WaitForChild("HumanoidRootPart")
	
	local currentPrompt = nil

	local function cleanupPrompt()
		if currentPrompt then
			currentPrompt:Destroy()
			currentPrompt = nil
		end
	end

	local function onDownedChanged()
		local isDowned = character:GetAttribute("IsDowned")

		if isDowned then
			if currentPrompt then return end -- Already exists

			local prompt = Instance.new("ProximityPrompt")
			prompt.ActionText = "Revive"
			prompt.HoldDuration = 3
			prompt.RequiresLineOfSight = false
			prompt.MaxActivationDistance = 10
			prompt.Parent = hrp
			currentPrompt = prompt

			prompt.Triggered:Connect(function(reviver)
				if reviver.Character == character then return end -- Prevent self-revive

				humanoid.Health = 50
				character:SetAttribute("IsDowned", false)
				humanoid.Sit = false
				humanoid.WalkSpeed = 16
				humanoid.JumpPower = 50
				cleanupPrompt()
			end)
		else
			cleanupPrompt()
		end
	end

	-- Initial check in case attribute is already true on spawn
	onDownedChanged()

	-- Listen for attribute changes
	local attributeConnection = character:GetAttributeChangedSignal("IsDowned"):Connect(onDownedChanged)

	-- Cleanup connections when character is removed
	character.Destroying:Once(function()
		attributeConnection:Disconnect()
		cleanupPrompt()
	end)
end

Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(setupCharacter)
	if player.Character then
		task.spawn(setupCharacter, player.Character)
	end
end)