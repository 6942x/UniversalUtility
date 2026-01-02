local UI = _G.UniversalUtility.UI
local Helpers = _G.UniversalUtility.Helpers
local KeyCodeNames = _G.UniversalUtility.KeyCodeNames
local Config = _G.UniversalUtility.Config
local function CreateSettingsTab()
    local SettingsContent = UI.TabContents["Settings"]

    local Container = Instance.new("Frame", SettingsContent)
    Container.Size = UDim2.new(1, 0, 0, 230)
    Container.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
    Container.BorderSizePixel = 0
    Container.LayoutOrder = 1
    Instance.new("UICorner", Container).CornerRadius = UDim.new(0, 10)

    local ContainerGradient = Instance.new("UIGradient", Container)
    ContainerGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 35, 42)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 40, 47))
    }
    ContainerGradient.Rotation = 90

    local Title = Instance.new("TextLabel", Container)
    Title.Size = UDim2.new(1, -20, 0, 26)
    Title.Position = UDim2.new(0, 10, 0, 8)
    Title.BackgroundTransparency = 1
    Title.Text = "⚙️ UI Configuration"
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 18
    Title.TextColor3 = Color3.fromRGB(255, 180, 100)
    Title.TextXAlignment = Enum.TextXAlignment.Left

    local Description = Instance.new("TextLabel", Container)
    Description.Size = UDim2.new(1, -20, 0, 16)
    Description.Position = UDim2.new(0, 10, 0, 34)
    Description.BackgroundTransparency = 1
    Description.Text = "Customize interface preferences and keybinds"
    Description.Font = Enum.Font.Gotham
    Description.TextSize = 11
    Description.TextColor3 = Color3.fromRGB(150, 150, 150)
    Description.TextXAlignment = Enum.TextXAlignment.Left

    local KeybindLabel = Instance.new("TextLabel", Container)
    KeybindLabel.Size = UDim2.new(1, -20, 0, 20)
    KeybindLabel.Position = UDim2.new(0, 10, 0, 60)
    KeybindLabel.BackgroundTransparency = 1
    KeybindLabel.Text = "Toggle Keybind"
    KeybindLabel.Font = Enum.Font.GothamBold
    KeybindLabel.TextSize = 13
    KeybindLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    KeybindLabel.TextXAlignment = Enum.TextXAlignment.Left

    local keyName = KeyCodeNames[Config.Keybind] or Config.Keybind.Name
    local KeybindButton = Helpers.CreateButton(Container, UDim2.new(0, 220, 0, 40), "Current Key: " .. keyName)
    KeybindButton.Position = UDim2.new(0.5, 0, 0, 90)

    local StatusFrame = Instance.new("Frame", Container)
    StatusFrame.Size = UDim2.new(1, -20, 0, 85)
    StatusFrame.Position = UDim2.new(0, 10, 0, 140)
    StatusFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    StatusFrame.BorderSizePixel = 0
    Instance.new("UICorner", StatusFrame).CornerRadius = UDim.new(0, 8)
    Instance.new("UIStroke", StatusFrame).Color = Color3.fromRGB(50, 50, 60)

    local Status = Instance.new("TextLabel", StatusFrame)
    Status.Size = UDim2.new(1, -20, 1, -20)
    Status.Position = UDim2.new(0, 10, 0, 10)
    Status.BackgroundTransparency = 1
    Status.Text = "Click the button above to change your toggle keybind.\n\nPress the assigned keybind at any time to show or hide this menu. The keybind is saved automatically."
    Status.Font = Enum.Font.Gotham
    Status.TextSize = 12
    Status.TextColor3 = Color3.fromRGB(150, 150, 150)
    Status.TextXAlignment = Enum.TextXAlignment.Center
    Status.TextYAlignment = Enum.TextYAlignment.Top
    Status.TextWrapped = true

    return {
        KeybindButton = KeybindButton,
        Status = Status
    }
end
return CreateSettingsTab
