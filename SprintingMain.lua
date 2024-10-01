local Sprinting = false

local Stamina = 100
local Exhausted = false

local Caption = require(game.Players.LocalPlayer.PlayerGui.Main.Client.MainClient.SubTitles)

local Character = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:FindFirstChildOfClass("Humanoid")

local StaminaOut = {
	"I'm exhausted.",
	"I don't want to run.",
	"I'm tired."
}

local TS = game:GetService("TweenService")

local MainSprintUI = game:GetObjects("rbxassetid://92619396678725")[1]
MainSprintUI.Parent = game.Players.LocalPlayer.PlayerGui.Main
MainSprintUI.TextLabel.Text = "STAMINA"
print("Stamina Loaded")
if not MainSprintUI.Visible then MainSprintUI.Visible = true end
game:GetService("RunService").RenderStepped:Connect(function()
	MainSprintUI.Outer.Bar.Size = UDim2.fromScale(1,Stamina * .01)
	if Sprinting then
		Stamina = math.clamp(Stamina - .35,0,100)
		Humanoid.WalkSpeed = 24
		
		TS:Create(workspace.CurrentCamera,TweenInfo.new(.5),{
			FieldOfView = 108.5
		}):Play()
		
		if not game.Players.LocalPlayer:FindFirstChild("Running").Value 
			or game.Players.LocalPlayer:FindFirstChild("Crouching").Value then
			Sprinting = false
			Humanoid.WalkSpeed = 16
			TS:Create(workspace.CurrentCamera,TweenInfo.new(.5),{
				FieldOfView = 90
			}):Play()
		end
		if Stamina == 0 then
			Sprinting = false
			Humanoid.WalkSpeed = 16
			TS:Create(workspace.CurrentCamera,TweenInfo.new(.5),{
				FieldOfView = 90
			}):Play()
			Exhausted = true
			TS:Create(MainSprintUI.Outer.Bar,TweenInfo.new(.5),{
				BackgroundColor3 = Color3.fromRGB(255, 124, 124)
			}):Play()
		end
		
	else
		Stamina = math.clamp(Stamina + .1,0,100)
		if Stamina >= 50 and Exhausted then
			Exhausted = false
			TS:Create(MainSprintUI.Outer.Bar,TweenInfo.new(.5),{
				BackgroundColor3 = Color3.fromRGB(183, 215, 255)
			}):Play()
		end
	end
end)

game.UserInputService.InputBegan:Connect(function(INPUT)
	if INPUT.KeyCode == Enum.KeyCode.Q then
		if Exhausted then
			local hey = Caption.new(StaminaOut[math.random(1,#StaminaOut)],2) 
			hey:Show()
			return
		end
		if game.Players.LocalPlayer:FindFirstChild("Crouching").Value
			or not game.Players.LocalPlayer:FindFirstChild("Running").Value then
			return
		end
		Sprinting = true
	end
end)
game.UserInputService.InputEnded:Connect(function(INPUT)
	if INPUT.KeyCode == Enum.KeyCode.Q and Sprinting then
		Sprinting = false
		Humanoid.WalkSpeed = 16
		TS:Create(workspace.CurrentCamera,TweenInfo.new(.5),{
				FieldOfView = 90
			}):Play()
	end
end)
