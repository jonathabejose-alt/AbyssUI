local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local Camera = workspace.CurrentCamera

local CONFIG = {
    Speed = 150,
    Keybind = Enum.KeyCode.U,
    ButtonPosition = UDim2.new(0.5, -90, 0, 10)
}

LocalPlayer.CharacterAdded:Connect(function(char)
    Character = char
    Humanoid = char:WaitForChild("Humanoid")
    if not IsActive then
        Camera.CameraSubject = Humanoid
    end
end)

local function safeCameraFix()
    if IsActive then
        local Ball = findBall()
        if not Ball or not Ball.Parent then
            if Humanoid and Humanoid.Parent then
                Camera.CameraSubject = Humanoid
            end
        end
    end
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Ball Control"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 220, 0, 180)
MainFrame.Position = CONFIG.ButtonPosition
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = false
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(60, 60, 70)
MainStroke.Thickness = 1.5
MainStroke.Parent = MainFrame

local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 36)
TitleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = TitleBar

local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(1, -50, 1, 0)
TitleText.Position = UDim2.new(0, 14, 0, 0)
TitleText.Text = "Ball Control"
TitleText.Font = Enum.Font.GothamBold
TitleText.TextSize = 13
TitleText.TextColor3 = Color3.fromRGB(220, 220, 230)
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.BackgroundTransparency = 1
TitleText.Parent = TitleBar

local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 28, 0, 28)
MinimizeBtn.Position = UDim2.new(1, -34, 0, 4)
MinimizeBtn.Text = "—"
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.TextSize = 16
MinimizeBtn.TextColor3 = Color3.fromRGB(180, 180, 190)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 58)
MinimizeBtn.BorderSizePixel = 0
MinimizeBtn.Parent = TitleBar

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 6)
MinCorner.Parent = MinimizeBtn

local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -20, 1, -46)
ContentFrame.Position = UDim2.new(0, 10, 0, 42)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

local ContentList = Instance.new("UIListLayout")
ContentList.Padding = UDim.new(0, 8)
ContentList.HorizontalAlignment = Enum.HorizontalAlignment.Center
ContentList.SortOrder = Enum.SortOrder.LayoutOrder
ContentList.Parent = ContentFrame

local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Size = UDim2.new(1, 0, 0, 40)
ToggleButton.Text = "START CONTROL"
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextSize = 14
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 170, 100)
ToggleButton.BorderSizePixel = 0
ToggleButton.LayoutOrder = 1
ToggleButton.Parent = ContentFrame

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 8)
ToggleCorner.Parent = ToggleButton

local ToggleGradient = Instance.new("UIGradient")
ToggleGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 200, 120)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 150, 80))
})
ToggleGradient.Rotation = 90
ToggleGradient.Parent = ToggleButton

local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Size = UDim2.new(1, 0, 0, 18)
SpeedLabel.Text = "Speed: " .. CONFIG.Speed
SpeedLabel.Font = Enum.Font.GothamSemibold
SpeedLabel.TextSize = 12
SpeedLabel.TextColor3 = Color3.fromRGB(180, 180, 190)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
SpeedLabel.LayoutOrder = 2
SpeedLabel.Parent = ContentFrame

local SpeedSlider = Instance.new("Frame")
SpeedSlider.Size = UDim2.new(1, 0, 0, 6)
SpeedSlider.BackgroundColor3 = Color3.fromRGB(50, 50, 58)
SpeedSlider.BorderSizePixel = 0
SpeedSlider.LayoutOrder = 3
SpeedSlider.Parent = ContentFrame

local SliderCorner = Instance.new("UICorner")
SliderCorner.CornerRadius = UDim.new(1, 0)
SliderCorner.Parent = SpeedSlider

local SpeedFill = Instance.new("Frame")
SpeedFill.Size = UDim2.new(CONFIG.Speed / 400, 0, 1, 0)
SpeedFill.BackgroundColor3 = Color3.fromRGB(0, 180, 220)
SpeedFill.BorderSizePixel = 0
SpeedFill.Parent = SpeedSlider

local FillCorner = Instance.new("UICorner")
FillCorner.CornerRadius = UDim.new(1, 0)
FillCorner.Parent = SpeedFill

local SpeedKnob = Instance.new("TextButton")
SpeedKnob.Size = UDim2.new(0, 16, 0, 16)
SpeedKnob.Position = UDim2.new(CONFIG.Speed / 400, -8, 0.5, -8)
SpeedKnob.Text = ""
SpeedKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SpeedKnob.BorderSizePixel = 0
SpeedKnob.Parent = SpeedSlider

local KnobCorner = Instance.new("UICorner")
KnobCorner.CornerRadius = UDim.new(1, 0)
KnobCorner.Parent = SpeedKnob

local KnobStroke = Instance.new("UIStroke")
KnobStroke.Color = Color3.fromRGB(0, 180, 220)
KnobStroke.Thickness = 2
KnobStroke.Parent = SpeedKnob

local KeybindFrame = Instance.new("Frame")
KeybindFrame.Size = UDim2.new(1, 0, 0, 32)
KeybindFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 52)
KeybindFrame.BorderSizePixel = 0
KeybindFrame.LayoutOrder = 4
KeybindFrame.Parent = ContentFrame

local KeybindCorner = Instance.new("UICorner")
KeybindCorner.CornerRadius = UDim.new(0, 8)
KeybindCorner.Parent = KeybindFrame

local KeybindLabel = Instance.new("TextLabel")
KeybindLabel.Size = UDim2.new(0, 60, 1, 0)
KeybindLabel.Text = "Keybind:"
KeybindLabel.Font = Enum.Font.GothamSemibold
KeybindLabel.TextSize = 12
KeybindLabel.TextColor3 = Color3.fromRGB(180, 180, 190)
KeybindLabel.BackgroundTransparency = 1
KeybindLabel.TextXAlignment = Enum.TextXAlignment.Left
KeybindLabel.Position = UDim2.new(0, 10, 0, 0)
KeybindLabel.Parent = KeybindFrame

local KeybindButton = Instance.new("TextButton")
KeybindButton.Size = UDim2.new(1, -80, 0, 22)
KeybindButton.Position = UDim2.new(0, 70, 0.5, -11)
KeybindButton.Text = CONFIG.Keybind.Name
KeybindButton.Font = Enum.Font.GothamBold
KeybindButton.TextSize = 12
KeybindButton.TextColor3 = Color3.fromRGB(255, 255, 255)
KeybindButton.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
KeybindButton.BorderSizePixel = 0
KeybindButton.Parent = KeybindFrame

local KeybindBtnCorner = Instance.new("UICorner")
KeybindBtnCorner.CornerRadius = UDim.new(0, 6)
KeybindBtnCorner.Parent = KeybindButton

local isCollapsed = false
local originalSize = MainFrame.Size

MinimizeBtn.MouseButton1Click:Connect(function()
    isCollapsed = not isCollapsed
    if isCollapsed then
        MainFrame.Size = UDim2.new(originalSize.X.Scale, originalSize.X.Offset, 0, 36)
        ContentFrame.Visible = false
    else
        MainFrame.Size = originalSize
        ContentFrame.Visible = true
    end
end)

local dragging = false
local dragOffset = Vector2.zero

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragOffset = input.Position - MainFrame.AbsolutePosition
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        MainFrame.Position = UDim2.fromOffset(
            input.Position.X - dragOffset.X,
            input.Position.Y - dragOffset.Y
        )
        CONFIG.ButtonPosition = MainFrame.Position
    end
end)

local isSliding = false

SpeedKnob.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isSliding = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    isSliding = false
end)

local function updateSpeedFromSlider(inputX)
    local sliderAbsX = SpeedSlider.AbsolutePosition.X
    local sliderWidth = SpeedSlider.AbsoluteSize.X
    local relativeX = math.clamp(inputX - sliderAbsX, 0, sliderWidth)
    local percent = relativeX / sliderWidth
    local newSpeed = math.floor(50 + percent * 350) -- Range: 50 to 400

    CONFIG.Speed = newSpeed
    SpeedFill.Size = UDim2.new(percent, 0, 1, 0)
    SpeedKnob.Position = UDim2.new(percent, -8, 0.5, -8)
    SpeedLabel.Text = "Speed: " .. newSpeed

    if IsActive and BodyVelocity then
        BodyVelocity.Velocity = Camera.CFrame.LookVector * CONFIG.Speed
    end
end

UserInputService.InputChanged:Connect(function(input)
    if isSliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        updateSpeedFromSlider(input.Position.X)
    end
end)

SpeedSlider.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        updateSpeedFromSlider(input.Position.X)
        isSliding = true
    end
end)

local listeningForKey = false
local keybindConnection

local function handleKeybindPress(input, gp)
    if gp then return end
    
    if listeningForKey then
        listeningForKey = false
        CONFIG.Keybind = input.KeyCode
        KeybindButton.Text = input.KeyCode.Name
        KeybindButton.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
        return
    end
    
    if input.KeyCode == CONFIG.Keybind then
        toggleControl()
    end
end

keybindConnection = UserInputService.InputBegan:Connect(handleKeybindPress)

KeybindButton.MouseButton1Click:Connect(function()
    listeningForKey = true
    KeybindButton.Text = "..."
    KeybindButton.BackgroundColor3 = Color3.fromRGB(220, 180, 0)
end)

local Ball = nil
local BodyVelocity = nil
local Connection = nil
local IsActive = false

local function findBall()
    return workspace:FindFirstChild("Ball")
end

local function stopControl()
    if Connection then
        Connection:Disconnect()
        Connection = nil
    end

    if BodyVelocity then
        BodyVelocity:Destroy()
        BodyVelocity = nil
    end

    if Humanoid and Humanoid.Parent then
        Camera.CameraSubject = Humanoid
    end
    
    IsActive = false
    ToggleButton.Text = "START CONTROL"
    ToggleGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 200, 120)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 150, 80))
    })
end

local function startControl()
    Ball = findBall()
    if not Ball then
        -- Visual error feedback
        ToggleButton.Text = "BALL NOT FOUND!"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        task.wait(2)
        ToggleButton.Text = "START CONTROL"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 170, 100)
        IsActive = false
        return
    end

    BodyVelocity = Instance.new("BodyVelocity")
    BodyVelocity.MaxForce = Vector3.new(1e6, 1e6, 1e6)
    BodyVelocity.Velocity = Vector3.zero
    BodyVelocity.Parent = Ball

    Camera.CameraSubject = Ball

    Connection = RunService.Heartbeat:Connect(function()
        if not IsActive then
            stopControl()
            return
        end
        if not Ball or not Ball.Parent then
            stopControl()
            safeCameraFix()
            return
        end

        local lookVector = Camera.CFrame.LookVector
        BodyVelocity.Velocity = Vector3.new(
            lookVector.X * CONFIG.Speed,
            lookVector.Y * CONFIG.Speed,
            lookVector.Z * CONFIG.Speed
        )
    end)
    
    ToggleButton.Text = "STOP CONTROL"
    ToggleGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 200, 120)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 150, 80))
    })
end

function toggleControl()
    IsActive = not IsActive

    if IsActive then
        startControl()
    else
        stopControl()
    end
end

ToggleButton.MouseButton1Click:Connect(function()
    toggleControl()
end)

LocalPlayer.OnPlayerLeaving:Connect(function()
    stopControl()
    if keybindConnection then
        keybindConnection:Disconnect()
    end
    ScreenGui:Destroy()
end)


RunService.Heartbeat:Connect(function()
    safeCameraFix()
end)
