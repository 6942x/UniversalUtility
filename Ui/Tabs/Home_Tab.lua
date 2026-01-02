local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local UI = _G.UniversalUtility.UI

local function CreateHomeTab()
    local HomeContent = UI.TabContents["Home"]
    
    local PlayerInfoFrame = Instance.new("Frame", HomeContent)
    PlayerInfoFrame.Size = UDim2.new(1, 0, 0, 180)
    PlayerInfoFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
    PlayerInfoFrame.BorderSizePixel = 0
    PlayerInfoFrame.LayoutOrder = 1
    Instance.new("UICorner", PlayerInfoFrame).CornerRadius = UDim.new(0, 10)
    
    local PlayerInfoGradient = Instance.new("UIGradient", PlayerInfoFrame)
    PlayerInfoGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 35, 42)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 40, 47))
    }
    PlayerInfoGradient.Rotation = 45
    
    local PlayerImage = Instance.new("ImageLabel", PlayerInfoFrame)
    PlayerImage.Size = UDim2.new(0, 120, 0, 140)
    PlayerImage.Position = UDim2.new(0, 10, 0, 10)
    PlayerImage.BackgroundColor3 = Color3.fromRGB(45, 45, 52)
    PlayerImage.BorderSizePixel = 0
    PlayerImage.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    Instance.new("UICorner", PlayerImage).CornerRadius = UDim.new(0, 10)
    Instance.new("UIStroke", PlayerImage).Color = Color3.fromRGB(100, 150, 255)
    
    local PlayerName = Instance.new("TextLabel", PlayerInfoFrame)
    PlayerName.Size = UDim2.new(1, -145, 0, 22)
    PlayerName.Position = UDim2.new(0, 140, 0, 10)
    PlayerName.BackgroundTransparency = 1
    PlayerName.Text = LocalPlayer.Name
    PlayerName.Font = Enum.Font.GothamBold
    PlayerName.TextSize = 28
    PlayerName.TextColor3 = Color3.fromRGB(255, 255, 255)
    PlayerName.TextXAlignment = Enum.TextXAlignment.Left
    
    local PlayerInfoLabel = Instance.new("TextLabel", PlayerInfoFrame)
    PlayerInfoLabel.Size = UDim2.new(1, -145, 0, 16)
    PlayerInfoLabel.Position = UDim2.new(0, 140, 0, 37)
    PlayerInfoLabel.BackgroundTransparency = 1
    PlayerInfoLabel.Text = "User ID: " .. LocalPlayer.UserId
    PlayerInfoLabel.Font = Enum.Font.Gotham
    PlayerInfoLabel.TextSize = 12
    PlayerInfoLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    PlayerInfoLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local FPSLabel = Instance.new("TextLabel", PlayerInfoFrame)
    FPSLabel.Size = UDim2.new(1, -145, 0, 18)
    FPSLabel.Position = UDim2.new(0, 140, 0, 65)
    FPSLabel.BackgroundTransparency = 1
    FPSLabel.Text = "FPS: 60"
    FPSLabel.Font = Enum.Font.Gotham
    FPSLabel.TextSize = 20
    FPSLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
    FPSLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local PingLabel = Instance.new("TextLabel", PlayerInfoFrame)
    PingLabel.Size = UDim2.new(1, -145, 0, 18)
    PingLabel.Position = UDim2.new(0, 140, 0, 95)
    PingLabel.BackgroundTransparency = 1
    PingLabel.Text = "Ping: 0 ms"
    PingLabel.Font = Enum.Font.Gotham
    PingLabel.TextSize = 20
    PingLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    PingLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local executorName, executorVersion = "Unknown", "N/A"
    if identifyexecutor then
        executorName, executorVersion = identifyexecutor()
    elseif getexecutorname then
        executorName = getexecutorname()
    end
    
    local ExecutorLabel = Instance.new("TextLabel", PlayerInfoFrame)
    ExecutorLabel.Size = UDim2.new(1, -145, 0, 18)
    ExecutorLabel.Position = UDim2.new(0, 140, 0, 125)
    ExecutorLabel.BackgroundTransparency = 1
    ExecutorLabel.Text = "Executor: " .. executorName .. " " .. executorVersion
    ExecutorLabel.Font = Enum.Font.Gotham
    ExecutorLabel.TextSize = 20
    ExecutorLabel.TextColor3 = Color3.fromRGB(255, 100, 200)
    ExecutorLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local GameInfoFrame = Instance.new("Frame", HomeContent)
    GameInfoFrame.Size = UDim2.new(1, 0, 0, 220)
    GameInfoFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
    GameInfoFrame.BorderSizePixel = 0
    GameInfoFrame.LayoutOrder = 2
    Instance.new("UICorner", GameInfoFrame).CornerRadius = UDim.new(0, 10)
    
    local GameInfoGradient = Instance.new("UIGradient", GameInfoFrame)
    GameInfoGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 35, 42)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 40, 47))
    }
    GameInfoGradient.Rotation = 135
    
    local GameImage = Instance.new("ImageLabel", GameInfoFrame)
    GameImage.Size = UDim2.new(0, 120, 0, 140)
    GameImage.Position = UDim2.new(0, 10, 0, 10)
    GameImage.BackgroundColor3 = Color3.fromRGB(45, 45, 52)
    GameImage.BorderSizePixel = 0
    GameImage.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    Instance.new("UICorner", GameImage).CornerRadius = UDim.new(0, 10)
    Instance.new("UIStroke", GameImage).Color = Color3.fromRGB(100, 150, 255)
    
    local GameName = Instance.new("TextLabel", GameInfoFrame)
    GameName.Size = UDim2.new(1, -145, 0, 24)
    GameName.Position = UDim2.new(0, 140, 0, 10)
    GameName.BackgroundTransparency = 1
    GameName.Text = "Loading game information..."
    GameName.Font = Enum.Font.GothamBold
    GameName.TextSize = 24
    GameName.TextColor3 = Color3.fromRGB(255, 255, 255)
    GameName.TextXAlignment = Enum.TextXAlignment.Left
    GameName.TextWrapped = true
    
    local GameId = Instance.new("TextLabel", GameInfoFrame)
    GameId.Size = UDim2.new(1, -145, 0, 18)
    GameId.Position = UDim2.new(0, 140, 0, 50)
    GameId.BackgroundTransparency = 1
    GameId.Text = "Place ID: " .. game.PlaceId
    GameId.Font = Enum.Font.Gotham
    GameId.TextSize = 20
    GameId.TextColor3 = Color3.fromRGB(150, 180, 255)
    GameId.TextXAlignment = Enum.TextXAlignment.Left
    
    local PlayersInServerLabel = Instance.new("TextLabel", GameInfoFrame)
    PlayersInServerLabel.Size = UDim2.new(1, -145, 0, 18)
    PlayersInServerLabel.Position = UDim2.new(0, 140, 0, 80)
    PlayersInServerLabel.BackgroundTransparency = 1
    PlayersInServerLabel.Text = "Players Connected: " .. #Players:GetPlayers()
    PlayersInServerLabel.Font = Enum.Font.Gotham
    PlayersInServerLabel.TextSize = 20
    PlayersInServerLabel.TextColor3 = Color3.fromRGB(150, 255, 180)
    PlayersInServerLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local ServerIdLabel = Instance.new("TextLabel", GameInfoFrame)
    ServerIdLabel.Size = UDim2.new(1, -145, 0, 18)
    ServerIdLabel.Position = UDim2.new(0, 140, 0, 110)
    ServerIdLabel.BackgroundTransparency = 1
    ServerIdLabel.Text = "Server JobId: " .. game.JobId
    ServerIdLabel.Font = Enum.Font.Gotham
    ServerIdLabel.TextSize = 12
    ServerIdLabel.TextColor3 = Color3.fromRGB(255, 180, 180)
    ServerIdLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    RunService.Heartbeat:Connect(function()
        PlayersInServerLabel.Text = "Players Connected: " .. #Players:GetPlayers()
    end)
    
    UI.PlayerImage = PlayerImage
    UI.GameName = GameName
    UI.GameImage = GameImage
    
    return {
        FPSLabel = FPSLabel,
        PingLabel = PingLabel
    }
end

return CreateHomeTab
