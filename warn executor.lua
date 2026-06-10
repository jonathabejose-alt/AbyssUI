--!optimize 2
--!native

local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

-- Load custom icons from Footagesus/Icons
local Icons = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/Footagesus/Icons/main/Main-v2.lua"))()
Icons.SetIconsType("lucide")

-- Detect executor functions
local hasRequest = request or http_request or (syn and syn.request) or (http and http.request)
local hasWriteFile = writefile or write_file
local hasGetCustomAsset = getcustomasset or get_custom_asset or getsynasset or get_syn_asset
local hasSetClipboard = setclipboard or toclipboard or set_clipboard or to_clipboard or (syn and syn.write_clipboard)

-- Check compatibility
local compatible = hasRequest and hasWriteFile and hasGetCustomAsset

-- Customizable configuration
local CONFIG = {
    title = "ABYSS_UI.exe",
    gameName = "Unknown Game",
    missingFeatures = {},
    siteUrl = "https://weao.xyz/",
    discordInvite = "weaoxyz",
    primaryButton = "VIEW EXECUTORS",
    secondaryButton = "CANCEL",
    tertiaryButton = "RUN ANYWAY",
    forceRunAnyway = true,
    yields = true,
}

-- Detect missing features
if not hasRequest then table.insert(CONFIG.missingFeatures, "http.request") end
if not hasWriteFile then table.insert(CONFIG.missingFeatures, "writefile") end
if not hasGetCustomAsset then table.insert(CONFIG.missingFeatures, "getcustomasset") end
if not hasSetClipboard then table.insert(CONFIG.missingFeatures, "setclipboard") end

-- Get game name
local GAME_ID = game.PlaceId
local GAME_NAME = game:GetService("MarketplaceService"):GetProductInfo(GAME_ID).Name or "Unknown Game"
CONFIG.gameName = GAME_NAME

-- Terminal-style interface
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AbyssWarning"
ScreenGui.Parent = CoreGui
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false

local Background = Instance.new("Frame")
Background.Size = UDim2.new(1, 0, 1, 0)
Background.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Background.BackgroundTransparency = 1
Background.BorderSizePixel = 0
Background.Parent = ScreenGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 560, 0, 400)
MainFrame.Position = UDim2.new(0.5, -280, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.BackgroundTransparency = 1
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local Scale = Instance.new("UIScale")
Scale.Scale = 0.85
Scale.Parent = MainFrame

local Border = Instance.new("UIStroke", MainFrame)
Border.Thickness = 1
Border.Color = Color3.fromRGB(0, 255, 70)
Border.Transparency = 1

local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 28)
TopBar.Position = UDim2.new(0, 0, 0, 0)
TopBar.BackgroundColor3 = Color3.fromRGB(0, 255, 70)
TopBar.BackgroundTransparency = 1
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

-- Top bar icon (terminal)
local TopIcon = Icons.Image({
    Icon = "terminal",
    Size = UDim2.new(0, 14, 0, 14),
    Color = Color3.fromRGB(0, 0, 0),
})
TopIcon.IconFrame.Position = UDim2.new(0, 8, 0.5, -7)
TopIcon.IconFrame.Parent = TopBar

local TopTitle = Instance.new("TextLabel")
TopTitle.Size = UDim2.new(1, -60, 1, 0)
TopTitle.Position = UDim2.new(0, 28, 0, 0)
TopTitle.BackgroundTransparency = 1
TopTitle.Text = CONFIG.title
TopTitle.TextColor3 = Color3.fromRGB(0, 0, 0)
TopTitle.Font = Enum.Font.Code
TopTitle.TextSize = 12
TopTitle.TextXAlignment = Enum.TextXAlignment.Left
TopTitle.TextTransparency = 1
TopTitle.Parent = TopBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -28, 0, 0)
CloseBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 50)
CloseBtn.BackgroundTransparency = 1
CloseBtn.BorderSizePixel = 0
CloseBtn.Text = ""
CloseBtn.Visible = false
CloseBtn.ZIndex = 10
CloseBtn.Parent = MainFrame

-- Close button icon
local CloseIcon = Icons.Image({
    Icon = "x",
    Size = UDim2.new(0, 16, 0, 16),
    Color = Color3.fromRGB(0, 0, 0),
})
CloseIcon.IconFrame.Position = UDim2.new(0.5, -8, 0.5, -8)
CloseIcon.IconFrame.Parent = CloseBtn

local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, 0, 1, -28)
Content.Position = UDim2.new(0, 0, 0, 28)
Content.BackgroundTransparency = 1
Content.BorderSizePixel = 0
Content.Parent = MainFrame

-- Log system
local logLines = {}
local logY = 16
local userChoice = nil
local closed = false
local animationComplete = false

local function createLogLine(text, iconName, color, delay)
    local lineContainer = Instance.new("Frame")
    lineContainer.Size = UDim2.new(1, -24, 0, 18)
    lineContainer.Position = UDim2.new(0, 12, 0, logY)
    lineContainer.BackgroundTransparency = 1
    lineContainer.Visible = false
    lineContainer.Parent = Content
    
    local icon = nil
    if iconName then
        icon = Icons.Image({
            Icon = iconName,
            Size = UDim2.new(0, 12, 0, 12),
            Color = color or Color3.fromRGB(0, 255, 70),
        })
        icon.IconFrame.Position = UDim2.new(0, 0, 0.5, -6)
        icon.IconFrame.Parent = lineContainer
    end
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, icon and -18 or -12, 0, 18)
    label.Position = UDim2.new(0, icon and 18 or 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = ""
    label.TextColor3 = color or Color3.fromRGB(0, 255, 70)
    label.Font = Enum.Font.Code
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextTransparency = 1
    label.Parent = lineContainer
    
    logY = logY + 22
    table.insert(logLines, {label = label, text = text, delay = delay, container = lineContainer, icon = icon})
    return label
end

-- Buttons row
local ButtonRow = Instance.new("Frame")
ButtonRow.Size = UDim2.new(1, -24, 0, 35)
ButtonRow.Position = UDim2.new(0, 12, 1, -35)
ButtonRow.BackgroundTransparency = 1
ButtonRow.Visible = false
ButtonRow.Parent = Content

-- Helper function to create button with icon
local function createButton(text, iconName, bgColor, textColor, hoverColor)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 0, 1, 0)
    btn.BackgroundColor3 = bgColor or Color3.fromRGB(0, 80, 20)
    btn.BackgroundTransparency = 1
    btn.BorderSizePixel = 0
    btn.Text = ""
    btn.Visible = true
    btn.Parent = ButtonRow
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 4)
    btnCorner.Parent = btn
    
    local btnStroke = Instance.new("UIStroke")
    btnStroke.Color = textColor or Color3.fromRGB(0, 255, 70)
    btnStroke.Thickness = 1
    btnStroke.Transparency = 1
    btnStroke.Parent = btn
    
    local btnIcon = Icons.Image({
        Icon = iconName,
        Size = UDim2.new(0, 14, 0, 14),
        Color = textColor or Color3.fromRGB(0, 255, 70),
    })
    btnIcon.IconFrame.Position = UDim2.new(0, 8, 0.5, -7)
    btnIcon.IconFrame.Parent = btn
    
    local btnLabel = Instance.new("TextLabel")
    btnLabel.Size = UDim2.new(1, -28, 1, 0)
    btnLabel.Position = UDim2.new(0, 28, 0, 0)
    btnLabel.BackgroundTransparency = 1
    btnLabel.Text = text
    btnLabel.TextColor3 = textColor or Color3.fromRGB(0, 255, 70)
    btnLabel.Font = Enum.Font.Code
    btnLabel.TextSize = 12
    btnLabel.TextXAlignment = Enum.TextXAlignment.Left
    btnLabel.Parent = btn
    
    -- Hover effect
    local originalBg = btn.BackgroundColor3
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = hoverColor or bgColor, BackgroundTransparency = 0.3}):Play()
        TweenService:Create(btnStroke, TweenInfo.new(0.15), {Transparency = 0.2}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = originalBg, BackgroundTransparency = 1}):Play()
        TweenService:Create(btnStroke, TweenInfo.new(0.15), {Transparency = 1}):Play()
    end)
    
    return btn, btnStroke
end

-- Create buttons
local SecondaryBtn, SecondaryStroke = createButton(CONFIG.secondaryButton, "x-circle", Color3.fromRGB(0, 80, 20), Color3.fromRGB(0, 255, 70), Color3.fromRGB(0, 100, 30))
local TertiaryBtn, TertiaryStroke = createButton(CONFIG.tertiaryButton, "play", Color3.fromRGB(80, 60, 20), Color3.fromRGB(255, 200, 50), Color3.fromRGB(100, 80, 30))
local PrimaryBtn, PrimaryStroke = createButton(CONFIG.primaryButton, "external-link", Color3.fromRGB(0, 120, 40), Color3.fromRGB(0, 0, 0), Color3.fromRGB(0, 180, 60))

-- Set button sizes
SecondaryBtn.Size = UDim2.new(0.28, 0, 1, 0)
SecondaryBtn.Position = UDim2.new(0, 0, 0, 0)
TertiaryBtn.Size = UDim2.new(0.34, 0, 1, 0)
TertiaryBtn.Position = UDim2.new(0.33, 5, 0, 0)
PrimaryBtn.Size = UDim2.new(0.34, 0, 1, 0)
PrimaryBtn.Position = UDim2.new(0.66, 5, 0, 0)

-- Initially hide buttons
SecondaryBtn.Visible = false
TertiaryBtn.Visible = false
PrimaryBtn.Visible = false

-- Cursor animation
local Cursor = Instance.new("TextLabel")
Cursor.Size = UDim2.new(0, 10, 0, 18)
Cursor.BackgroundTransparency = 1
Cursor.Text = "_"
Cursor.TextColor3 = Color3.fromRGB(0, 255, 70)
Cursor.Font = Enum.Font.Code
Cursor.TextSize = 13
Cursor.TextTransparency = 1
Cursor.Parent = Content

-- Create log entries with icons
if not compatible then
    createLogLine("initializing compatibility check", "loader-circle", Color3.fromRGB(0, 255, 70), 0.8)
    createLogLine("game detected: " .. CONFIG.gameName, "gamepad-2", Color3.fromRGB(0, 200, 50), 1.2)
    createLogLine("checking executor functions", "search", Color3.fromRGB(0, 200, 50), 1.6)
    createLogLine("INCOMPATIBLE EXECUTOR DETECTED", "alert-triangle", Color3.fromRGB(255, 100, 50), 2.0)
    createLogLine("missing features:", "list", Color3.fromRGB(255, 200, 50), 2.4)
    
    for _, feature in ipairs(CONFIG.missingFeatures) do
        createLogLine("  " .. feature, "minus", Color3.fromRGB(255, 150, 50), 2.6)
    end
    
    createLogLine("recommended: use a compatible executor", "thumbs-up", Color3.fromRGB(0, 200, 50), 3.0)
    createLogLine("website: " .. CONFIG.siteUrl, "globe", Color3.fromRGB(0, 150, 200), 3.4)
    createLogLine("waiting for user input", "clock", Color3.fromRGB(0, 200, 50), 3.8)
else
    createLogLine("initializing AbyssUI", "loader-circle", Color3.fromRGB(0, 255, 70), 0.8)
    createLogLine("checking game ID: " .. GAME_ID, "hash", Color3.fromRGB(0, 200, 50), 1.2)
    createLogLine("game detected: " .. CONFIG.gameName, "gamepad-2", Color3.fromRGB(0, 255, 70), 1.6)
    createLogLine("executor is compatible", "check-circle", Color3.fromRGB(0, 255, 70), 2.0)
    createLogLine("loading modules", "package", Color3.fromRGB(0, 200, 50), 2.4)
    createLogLine("fetching scripts", "download", Color3.fromRGB(0, 200, 50), 2.8)
    createLogLine("preparing environment", "settings", Color3.fromRGB(0, 200, 50), 3.2)
    createLogLine("ready. launching", "rocket", Color3.fromRGB(0, 255, 70), 3.6)
end

-- Functions
local function copyToClipboard(text)
    if hasSetClipboard then
        setclipboard(text)
        
        local toast = Instance.new("Frame")
        toast.Size = UDim2.new(0, 120, 0, 24)
        toast.Position = UDim2.new(0.5, -60, 0.8, 0)
        toast.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        toast.BackgroundTransparency = 0.3
        toast.Parent = ScreenGui
        
        local toastCorner = Instance.new("UICorner")
        toastCorner.CornerRadius = UDim.new(0, 4)
        toastCorner.Parent = toast
        
        local checkIcon = Icons.Image({
            Icon = "check-circle",
            Size = UDim2.new(0, 14, 0, 14),
            Color = Color3.fromRGB(0, 255, 70),
        })
        checkIcon.IconFrame.Position = UDim2.new(0, 8, 0.5, -7)
        checkIcon.IconFrame.Parent = toast
        
        local toastText = Instance.new("TextLabel")
        toastText.Size = UDim2.new(1, -28, 1, 0)
        toastText.Position = UDim2.new(0, 28, 0, 0)
        toastText.BackgroundTransparency = 1
        toastText.Text = "copied: " .. text
        toastText.TextColor3 = Color3.fromRGB(0, 255, 70)
        toastText.Font = Enum.Font.Code
        toastText.TextSize = 11
        toastText.TextXAlignment = Enum.TextXAlignment.Left
        toastText.Parent = toast
        
        task.delay(1.5, function()
            TweenService:Create(toast, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
            task.delay(0.3, function() toast:Destroy() end)
        end)
    end
end

local function openDiscordInvite()
    if not hasRequest then return false end
    
    local body = '{"cmd":"INVITE_BROWSER","args":{"code":"' .. CONFIG.discordInvite .. '"},"nonce":"' .. tostring(math.random()) .. '"}'
    
    for port = 6463, 6472 do
        local success, response = pcall(request, {
            Url = "http://127.0.0.1:" .. port .. "/rpc?v=1",
            Method = "POST",
            Headers = {
                ["Content-Type"] = application/json",
                ["Origin"] = "https://discord.com",
            },
            Body = body,
        })
        
        if success and response and response.StatusCode and response.StatusCode < 400 then
            return true
        end
    end
    return false
end

-- Entry animation
local function animateEntry()
    TweenService:Create(Background, TweenInfo.new(0.4), {BackgroundTransparency = 0.08}):Play()
    TweenService:Create(MainFrame, TweenInfo.new(0.4), {BackgroundTransparency = 0}):Play()
    TweenService:Create(Scale, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()
    TweenService:Create(Border, TweenInfo.new(0.4), {Transparency = 0}):Play()
    
    task.delay(0.2, function()
        TweenService:Create(TopBar, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
        TweenService:Create(TopTitle, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
        CloseBtn.Visible = true
        TweenService:Create(CloseBtn, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
    end)
end

-- Exit animation
local function animateExit()
    for _, entry in ipairs(logLines) do
        TweenService:Create(entry.label, TweenInfo.new(0.15), {TextTransparency = 1}):Play()
        if entry.container then
            TweenService:Create(entry.container, TweenInfo.new(0.15), {BackgroundTransparency = 1}):Play()
        end
    end
    
    TweenService:Create(TopBar, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
    TweenService:Create(TopTitle, TweenInfo.new(0.2), {TextTransparency = 1}):Play()
    TweenService:Create(Border, TweenInfo.new(0.2), {Transparency = 1}):Play()
    TweenService:Create(Scale, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Scale = 0.85}):Play()
    TweenService:Create(MainFrame, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
    TweenService:Create(Background, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
    TweenService:Create(Cursor, TweenInfo.new(0.15), {TextTransparency = 1}):Play()
    
    if SecondaryStroke then TweenService:Create(SecondaryStroke, TweenInfo.new(0.15), {Transparency = 1}):Play() end
    if TertiaryStroke then TweenService:Create(TertiaryStroke, TweenInfo.new(0.15), {Transparency = 1}):Play() end
    if PrimaryStroke then TweenService:Create(PrimaryStroke, TweenInfo.new(0.15), {Transparency = 1}):Play() end
end

local function closeWarning(choice)
    if closed then return end
    closed = true
    userChoice = choice
    animateExit()
    task.delay(0.5, function() ScreenGui:Destroy() end)
end

-- Button actions
SecondaryBtn.MouseButton1Click:Connect(function() closeWarning("secondary") end)
TertiaryBtn.MouseButton1Click:Connect(function() closeWarning("tertiary") end)
PrimaryBtn.MouseButton1Click:Connect(function()
    copyToClipboard(CONFIG.siteUrl)
    openDiscordInvite()
    closeWarning("primary")
end)

-- Draggable window
local dragging = false
local dragStart = nil
local startPos = nil

TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

CloseBtn.MouseEnter:Connect(function()
    TweenService:Create(CloseIcon.IconFrame, TweenInfo.new(0.15), {ImageColor3 = Color3.fromRGB(255, 50, 50)}):Play()
end)
CloseBtn.MouseLeave:Connect(function()
    TweenService:Create(CloseIcon.IconFrame, TweenInfo.new(0.15), {ImageColor3 = Color3.fromRGB(0, 0, 0)}):Play()
end)
CloseBtn.MouseButton1Click:Connect(function() closeWarning("close") end)

-- Start entry animation
animateEntry()

-- Cursor blink animation
task.spawn(function()
    local cursorVisible = true
    while not closed do
        Cursor.TextTransparency = cursorVisible and 0 or 1
        cursorVisible = not cursorVisible
        task.wait(0.5)
    end
end)

-- Typewriter animation for log lines
task.spawn(function()
    for index, entry in ipairs(logLines) do
        local prevDelay = index > 1 and logLines[index - 1].delay or 0
        task.wait(entry.delay - prevDelay)
        if closed then break end
        
        -- Fade in the container
        entry.container.Visible = true
        TweenService:Create(entry.container, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
        
        if entry.icon then
            TweenService:Create(entry.icon.IconFrame, TweenInfo.new(0.2), {ImageTransparency = 0}):Play()
        end
        
        local label = entry.label
        local fullText = entry.text
        TweenService:Create(label, TweenInfo.new(0.1), {TextTransparency = 0}):Play()
        label.Text = ""
        
        -- Typewriter effect
        for i = 1, #fullText do
            if closed then break end
            label.Text = string.sub(fullText, 1, i)
            if label.TextBounds then
                Cursor.Position = UDim2.new(0, 12 + label.TextBounds.X, 0, label.Position.Y.Offset)
            end
            task.wait(0.018)
        end
    end
    
    if closed then return end
    
    animationComplete = true
    
    -- Show button row with animation
    ButtonRow.Visible = true
    ButtonRow.BackgroundTransparency = 1
    TweenService:Create(ButtonRow, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
    
    if not compatible then
        task.wait(0.3)
        
        -- Animate buttons appearing
        SecondaryBtn.Visible = true
        TweenService:Create(SecondaryBtn, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {BackgroundTransparency = 0}):Play()
        TweenService:Create(SecondaryStroke, TweenInfo.new(0.25), {Transparency = 0}):Play()
        
        if CONFIG.forceRunAnyway then
            task.wait(0.08)
            TertiaryBtn.Visible = true
            TweenService:Create(TertiaryBtn, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {BackgroundTransparency = 0}):Play()
            TweenService:Create(TertiaryStroke, TweenInfo.new(0.25), {Transparency = 0}):Play()
        end
        
        task.wait(0.08)
        PrimaryBtn.Visible = true
        TweenService:Create(PrimaryBtn, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {BackgroundTransparency = 0}):Play()
        TweenService:Create(PrimaryStroke, TweenInfo.new(0.25), {Transparency = 0}):Play()
        
        -- Wait for user choice
        repeat task.wait() until closed or userChoice ~= nil
    else
        -- Auto-close after animation for compatible executor
        task.wait(1.5)
        if not closed then
            closeWarning("auto")
        end
    end
end)

-- Return results if yielding
if CONFIG.yields then
    repeat task.wait() until closed
    return userChoice
end

return {
    close = function(choice) closeWarning(choice) end,
    getChoice = function() return userChoice end,
    isClosed = function() return closed end,
    gui = ScreenGui,
}
