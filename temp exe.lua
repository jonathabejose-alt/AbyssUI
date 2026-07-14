
workspace.map.gkbarriar.Abarriar.CanCollide = false
workspace.map.gkbarriar.Bbarriar.CanCollide = false
workspace.map.Agoal.CanCollide = false
workspace.map.Bgoal.CanCollide = false

local plr = game.Players.LocalPlayer
local rep = game:GetService("ReplicatedStorage")
local remote = rep:WaitForChild("ByteNetReliable")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")
local Players = game:GetService("Players")
local SoundService = game:GetService("SoundService")
local Workspace = game:GetService("Workspace")

local stopped = false
local exeAwkOnCD = false
local cooldowns = {}
local buffers = {}

local skillNames = {
    [1] = "Shortcut",
    [2] = "Exterminate",
    [3] = "EXE Strike",
    [4] = "Open Metavision"
}

loadstring(game:HttpGet("https://pastebin.com/raw/8XJh7dzh"))()
repeat task.wait() until game.Lighting:FindFirstChild("BUFFERSTRINGS")
for _, val in ipairs(game.Lighting:FindFirstChild("BUFFERSTRINGS"):GetChildren()) do
    buffers[val.Name] = val.Value
end
game.Lighting:FindFirstChild("BUFFERSTRINGS"):Destroy()

task.spawn(function()
    while not stopped do
        pcall(function()
            if workspace.map and workspace.map.gkbarriar then
                if workspace.map.gkbarriar.Abarriar then 
                    workspace.map.gkbarriar.Abarriar.CanCollide = false 
                end
                if workspace.map.gkbarriar.Bbarriar then 
                    workspace.map.gkbarriar.Bbarriar.CanCollide = false 
                end
            end
            if workspace.map.Agoal then workspace.map.Agoal.CanCollide = false end
            if workspace.map.Bgoal then workspace.map.Bgoal.CanCollide = false end
        end)
        task.wait(0.5)
    end
end)

local function DetectExecutor()
    local hasRequire = pcall(function() return require ~= nil end)
    local hasHook = hookmetamethod ~= nil
    local hasFenv = (getfenv ~= nil and setfenv ~= nil)
    local execName = "Unknown"
    if identifyexecutor then
        local success, name = pcall(identifyexecutor)
        if success and name then execName = name end
    elseif syn and syn.name then execName = syn.name
    elseif getexecutorname then execName = getexecutorname() end
    local isFull = hasRequire and hasHook and hasFenv
    return isFull, execName
end

local isFullExecutor, executorName = DetectExecutor()

if not isFullExecutor then
    game.StarterGui:SetCore("SendNotification", {
        Title = "Not Support Executor",
        Text = string.format("%s detected. Use a better executor.", executorName),
        Duration = 5,
        Button1 = "Ok",
        Icon = "rbxassetid://75337362546331"
    })
else
    game.StarterGui:SetCore("SendNotification", {
        Title = "Full Support",
        Text = string.format("%s detected. Fully supported!", executorName),
        Duration = 3,
        Button1 = "Ok",
        Icon = "rbxassetid://130521044774541"
    })
end

if not getgenv().MessiNotifyGUI then
    getgenv().MessiNotifyGUI = plr.PlayerGui.Notification:Clone()
    getgenv().MessiNotifyGUI.Name = string.gsub(tostring(math.random()), '0.', ''):sub(1, 1000) .. string.char(math.random(65, 90), math.random(97, 122), math.random(48, 57))
    getgenv().MessiNotifyGUI.Parent = game.CoreGui
end

task.spawn(function()
    local noti = getgenv().MessiNotifyGUI.Frame.base:Clone()
    noti.Parent = getgenv().MessiNotifyGUI.Frame
    noti.Visible = true
    noti.TextLabel.TextColor3 = Color3.fromRGB(200, 180, 0)
    game.Debris:AddItem(noti, 7.282)
    noti.TextLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    noti.TextLabel.TextStrokeTransparency = 1
    noti.TextLabel.TextTransparency = 1
    noti.TextLabel.Text = "EXE Moveset Loaded!"
    TweenService:Create(noti, TweenInfo.new(0.28, Enum.EasingStyle.Linear), {Size = UDim2.new(1.33, 0, 0.054, 0)}):Play()
    TweenService:Create(noti.TextLabel, TweenInfo.new(0.28, Enum.EasingStyle.Linear), {TextTransparency = 0}):Play()
    TweenService:Create(noti.TextLabel, TweenInfo.new(0.28, Enum.EasingStyle.Linear), {TextStrokeTransparency = 0}):Play()
    task.delay(7, function()
        TweenService:Create(noti.TextLabel, TweenInfo.new(0.28, Enum.EasingStyle.Linear), {TextTransparency = 1}):Play()
        TweenService:Create(noti.TextLabel, TweenInfo.new(0.28, Enum.EasingStyle.Linear), {TextStrokeTransparency = 1}):Play()
    end)
end)

task.wait(0.5)
task.spawn(function()
    local noti = getgenv().MessiNotifyGUI.Frame.base:Clone()
    noti.Parent = getgenv().MessiNotifyGUI.Frame
    noti.Visible = true
    noti.TextLabel.TextColor3 = Color3.fromRGB(200, 180, 0)
    game.Debris:AddItem(noti, 7.282)
    noti.TextLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    noti.TextLabel.TextStrokeTransparency = 1
    noti.TextLabel.TextTransparency = 1
    noti.TextLabel.Text = "Made By tze"
    TweenService:Create(noti, TweenInfo.new(0.28, Enum.EasingStyle.Linear), {Size = UDim2.new(1.33, 0, 0.054, 0)}):Play()
    TweenService:Create(noti.TextLabel, TweenInfo.new(0.28, Enum.EasingStyle.Linear), {TextTransparency = 0}):Play()
    TweenService:Create(noti.TextLabel, TweenInfo.new(0.28, Enum.EasingStyle.Linear), {TextStrokeTransparency = 0}):Play()
    task.delay(7, function()
        TweenService:Create(noti.TextLabel, TweenInfo.new(0.28, Enum.EasingStyle.Linear), {TextTransparency = 1}):Play()
        TweenService:Create(noti.TextLabel, TweenInfo.new(0.28, Enum.EasingStyle.Linear), {TextStrokeTransparency = 1}):Play()
    end)
end)

task.wait(1)
task.spawn(function()
    local noti = getgenv().MessiNotifyGUI.Frame.base:Clone()
    noti.Parent = getgenv().MessiNotifyGUI.Frame
    noti.Visible = true
    noti.TextLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
    game.Debris:AddItem(noti, 5.282)
    noti.TextLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    noti.TextLabel.TextStrokeTransparency = 1
    noti.TextLabel.TextTransparency = 1
    noti.TextLabel.Text = "You can now join a game!"
    TweenService:Create(noti, TweenInfo.new(0.28, Enum.EasingStyle.Linear), {Size = UDim2.new(1.33, 0, 0.054, 0)}):Play()
    TweenService:Create(noti.TextLabel, TweenInfo.new(0.28, Enum.EasingStyle.Linear), {TextTransparency = 0}):Play()
    TweenService:Create(noti.TextLabel, TweenInfo.new(0.28, Enum.EasingStyle.Linear), {TextStrokeTransparency = 0}):Play()
    task.delay(5, function()
        TweenService:Create(noti.TextLabel, TweenInfo.new(0.28, Enum.EasingStyle.Linear), {TextTransparency = 1}):Play()
        TweenService:Create(noti.TextLabel, TweenInfo.new(0.28, Enum.EasingStyle.Linear), {TextStrokeTransparency = 1}):Play()
    end)
end)

local watermarkObj = nil
if getgenv().MessiWatermarkName == nil or getgenv().MessiWatermarkName == '' then
    getgenv().MessiWatermarkName = string.gsub(tostring(math.random()), '0.', ''):sub(1, 1000) .. string.char(math.random(65, 90), math.random(97, 122), math.random(48, 57))
end
if not game.CoreGui.RobloxGui:FindFirstChild(getgenv().MessiWatermarkName) then
    setclipboard('https://discord.gg/Zu4PnN9Wxw')

    local discordText = getgenv().MessiNotifyGUI.Frame.base.TextLabel:Clone()
    discordText.Text = ' discord.gg/Zu4PnN9Wxw '
    discordText.Name = getgenv().MessiWatermarkName .. '2'
    discordText.Position = UDim2.new(0.05, 0, 0.142, 0)
    discordText.Size = discordText.Size - UDim2.new(0.1, 0, 0.1, 0)
    discordText.TextStrokeTransparency = 1
    discordText.TextColor3 = Color3.fromRGB(155, 0, 100)
    discordText.TextTransparency = 0.59

    watermarkObj = getgenv().MessiNotifyGUI.Frame.base.TextLabel:Clone()
    watermarkObj.Text = ' Made By tze '
    watermarkObj.Name = getgenv().MessiWatermarkName
    watermarkObj.Position = UDim2.new(0, 0, -0.02, 0)
    watermarkObj.TextStrokeTransparency = 1
    watermarkObj.TextColor3 = Color3.fromRGB(200, 180, 0)
    watermarkObj.TextTransparency = 0.59
    watermarkObj.Parent = game.CoreGui.RobloxGui
    
    discordText.Parent = watermarkObj
end

local function HasBall()
    return plr.Character and plr.Character:FindFirstChild("Ball")
end

local function Stunned()
    local char = plr.Character
    if not char then return true end
    local state = char:FindFirstChild("state")
    if not state then return true end
    local stun = state:FindFirstChild("stun")
    if not stun then return true end
    return stun.Value
end

local function CancelMove()
    local char = plr.Character
    if char then
        local state = char:FindFirstChild("state")
        if state then
            local stun = state:FindFirstChild("stun")
            if stun then
                stun.Value = true
                task.wait(0.04)
                stun.Value = false
            end
        end
    end
end

local function IsOnCD(name)
    local hotbar = plr.PlayerGui:FindFirstChild("Hotbar")
    if not hotbar then return false end
    local btn = hotbar.Backpack.Hotbar:FindFirstChild(name)
    if btn and btn:FindFirstChild("Cooldown") then return btn.Cooldown.Visible end
    return false
end

local function DoCD(name, duration)
    local hotbar = plr.PlayerGui:FindFirstChild("Hotbar")
    if not hotbar then return end
    local btn = hotbar.Backpack.Hotbar:FindFirstChild(name)
    if btn and btn:FindFirstChild("Cooldown") then
        btn.Cooldown.Visible = true
        btn.Cooldown.Size = UDim2.new(1, 0, -1, 0)
        TweenService:Create(btn.Cooldown, TweenInfo.new(duration, Enum.EasingStyle.Linear), {Size = UDim2.new(1, 0, 0, 0)}):Play()
        task.delay(duration, function() 
            if btn and btn.Cooldown then
                btn.Cooldown.Visible = false 
            end
        end)
    end
end

local function Stun(time, disableRotate)
    local char = plr.Character
    if not char then return end
    if char.state then
        char.state.stun.Value = true
    end
    if disableRotate then char:SetAttribute("disableRotate", true) end
    local cfg = Instance.new("Configuration")
    cfg:SetAttribute("speed", 0)
    cfg:SetAttribute("jump", 0)
    local movements = char:FindFirstChild("movements")
    if movements then
        cfg.Parent = movements
    end
    task.delay(time, function()
        pcall(function()
            if char and char.state then
                char.state.stun.Value = false
            end
            if disableRotate then 
                pcall(function() char:SetAttribute("disableRotate", false) end)
            end
        end)
    end)
    Debris:AddItem(cfg, time)
end

local function BodyVelocity(part, speed, duration)
    if not part then return end
    for _, v in pairs(part:GetChildren()) do
        if v:IsA("BodyVelocity") then v:Destroy() end
    end
    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(350000, 0, 350000)
    bv.Parent = part
    bv.Velocity = part.CFrame.LookVector * speed
    task.delay(duration, function()
        if bv and bv.Parent then bv:Destroy() end
    end)
    return bv
end

local function TeleportShot(char, shootDelay)
    local root = char.HumanoidRootPart
    task.delay(shootDelay, function()
        if not char or not char:FindFirstChild("HumanoidRootPart") or not char:FindFirstChild("Ball") then return end
        local originalCFrame = root.CFrame
        local lookVector = root.CFrame.LookVector
        local team = char.state.team.Value
        local oppositeTeam = team == "A" and "B" or "A"
        local goal = workspace.map and workspace.map:FindFirstChild(oppositeTeam .. "goal")
        local filterList = {char, workspace.Effects}
        if goal then table.insert(filterList, goal) end
        local gkBarrier = workspace.map and workspace.map:FindFirstChild("gkbarriar")
        if gkBarrier then
            local barrierPart = gkBarrier:FindFirstChild(oppositeTeam == "A" and "Abarriar" or "Bbarriar")
            if barrierPart then table.insert(filterList, barrierPart) end
        end
        local gkCheck = workspace.map and workspace.map:FindFirstChild(oppositeTeam .. "GoalkeeperCheck")
        if gkCheck then table.insert(filterList, gkCheck) end
        
        char:PivotTo(CFrame.new((function()
            local rayParams = RaycastParams.new()
            rayParams.FilterDescendantsInstances = filterList
            rayParams.FilterType = Enum.RaycastFilterType.Blacklist
            local rayResult = workspace:Raycast(root.Position, lookVector * 1000, rayParams)
            return rayResult and rayResult.Position - lookVector * 2 or root.Position
        end)()))
        root.CFrame = root.CFrame * CFrame.Angles(0, math.pi, 0) * CFrame.new(0, 0, -8.823999)
        task.wait(0.2)
        remote:FireServer(buffer.fromstring(buffers["base"]), {
            {"kick", 100, false, root.CFrame.LookVector * 1e19}
        })
        task.wait(0.001)
        root.CFrame = originalCFrame
    end)
end

local function BlockOriginalSkills()
    task.wait(0.1)
    local hotbar = plr.PlayerGui:FindFirstChild("Hotbar")
    if hotbar then
        local buttons = hotbar.Backpack.Hotbar
        for i = 1, 4 do
            local skill = buttons:FindFirstChild("skill" .. i)
            if skill and skill:FindFirstChild("Base") then
                local base = skill.Base
                base.Active = false
                base.AutoButtonColor = false
                pcall(function()
                    base.MouseButton1Click:DisconnectAll()
                    base.MouseButton1Down:DisconnectAll()
                end)
            end
        end
    end
end

local function Shortcut()
    local char = plr.Character
    if not char or Stunned() or IsOnCD("skill1") then return end

    CancelMove()
    DoCD("skill1", getgenv().EXE_Settings.Shortcut.Cooldown)

    local humanoid = char.Humanoid
    local root = char.HumanoidRootPart

    for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do track:Stop(0) end

    local anim = Instance.new("Animation")
    anim.AnimationId = "rbxassetid://116455589260954"
    local track = humanoid:LoadAnimation(anim)
    track.Priority = Enum.AnimationPriority.Action
    track:Play()

    pcall(function()
        require(rep.client.replication).DashSuper(char)
    end)

    local sound = Instance.new("Sound")
    sound.SoundId = getgenv().EXE_Settings.Shortcut.SoundId
    sound.Volume = getgenv().EXE_Settings.Shortcut.SoundVolume
    sound.Parent = root
    sound:Play()
    Debris:AddItem(sound, 3)

    if getgenv().USE_LONG_MOVES_MID_AIR then
        BodyVelocity(root, getgenv().EXE_Settings.Shortcut.Speed, getgenv().EXE_Settings.Shortcut.Duration)
    end

    Stun(0.3, false)

    task.delay(1.5, function()
        pcall(function()
            track:Stop()
        end)
    end)
end

local function Exterminate()
    local char = plr.Character
    if not char or Stunned() or IsOnCD("skill2") then return end
    if HasBall() then return end

    local ball = workspace.Terrain:FindFirstChild("Ball")
    if not ball then return end

    local root = char.HumanoidRootPart
    local dist = (root.Position - ball.Position).Magnitude
    if dist > getgenv().EXE_Settings.Exterminate.MaxDistance then return end

    CancelMove()
    DoCD("skill2", getgenv().EXE_Settings.Exterminate.Cooldown)

    local humanoid = char.Humanoid
    local originalCF = root.CFrame

    local targetPos = ball.Position + Vector3.new(0, 2, 0)
    root.CFrame = CFrame.new(targetPos, targetPos + Vector3.new(0, 0, -1))
    root.AssemblyLinearVelocity = Vector3.zero

    task.wait(0.1)

    local grabbed = false
    for i = 1, getgenv().EXE_Settings.Exterminate.GrabAttempts do
        remote:FireServer(buffer.fromstring(buffers["grabball"]))
        task.wait(0.05)
        if HasBall() then
            grabbed = true
            break
        end
        local currentBall = workspace.Terrain:FindFirstChild("Ball")
        if currentBall then
            local newPos = currentBall.Position + Vector3.new(0, 2, 0)
            root.CFrame = CFrame.new(newPos, newPos + Vector3.new(0, 0, -1))
        end
    end

    if not grabbed then
        root.CFrame = originalCF
        return
    end

    for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do track:Stop(0) end

    local anim = Instance.new("Animation")
    anim.AnimationId = "rbxassetid://71606482166598"
    local track = humanoid:LoadAnimation(anim)
    track.Priority = Enum.AnimationPriority.Action
    track:Play()

    if getgenv().USE_LONG_MOVES_MID_AIR then
        root.Anchored = true
    end

    pcall(function()
        require(rep.client.replication).TP(char)
    end)

    local sound = Instance.new("Sound")
    sound.SoundId = getgenv().EXE_Settings.Exterminate.SoundId
    sound.Volume = getgenv().EXE_Settings.Exterminate.SoundVolume
    sound.Parent = root
    sound:Play()
    Debris:AddItem(sound, 5)

    Stun(getgenv().EXE_Settings.Exterminate.StunDuration, true)

    local highlight = Instance.new("Highlight")
    highlight.FillTransparency = 0.6
    highlight.OutlineTransparency = 0.3
    highlight.Parent = char
    Debris:AddItem(highlight, 1.5)

    TweenService:Create(highlight, TweenInfo.new(1.5), {FillTransparency = 1}):Play()
    TweenService:Create(highlight, TweenInfo.new(1.5), {OutlineTransparency = 1}):Play()

    task.delay(getgenv().EXE_Settings.Exterminate.StunDuration, function()
        if getgenv().USE_LONG_MOVES_MID_AIR then
            root.Anchored = false
        end
        pcall(function()
            track:Stop()
        end)
    end)
end

local function EXEStrike()
    local char = plr.Character
    if not char or Stunned() or IsOnCD("skill3") then return end
    if not HasBall() then return end

    CancelMove()
    DoCD("skill3", getgenv().EXE_Settings.EXEStrike.Cooldown)

    local humanoid = char.Humanoid
    local root = char.HumanoidRootPart

    for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do track:Stop(0) end

    local anim = Instance.new("Animation")
    anim.AnimationId = "rbxassetid://111105572890621"
    local track = humanoid:LoadAnimation(anim)
    track.Priority = Enum.AnimationPriority.Action
    track:Play()

    if getgenv().USE_LONG_MOVES_MID_AIR then
        TweenService:Create(humanoid, TweenInfo.new(0.3, Enum.EasingStyle.Cubic), {HipHeight = getgenv().EXE_Settings.EXEStrike.ElevationHeight}):Play()
    end

    local sound1 = Instance.new("Sound")
    sound1.SoundId = getgenv().EXE_Settings.EXEStrike.Sound1Id
    sound1.Volume = getgenv().EXE_Settings.EXEStrike.Sound1Volume
    sound1.Parent = root
    sound1:Play()
    Debris:AddItem(sound1, 4)

    task.spawn(function()
        task.wait(getgenv().EXE_Settings.EXEStrike.Sound2Delay)
        local sound2 = Instance.new("Sound")
        sound2.SoundId = getgenv().EXE_Settings.EXEStrike.Sound2Id
        sound2.Volume = getgenv().EXE_Settings.EXEStrike.Sound2Volume
        sound2.Parent = root
        sound2:Play()
        Debris:AddItem(sound2, 5)
    end)

    pcall(function()
        require(rep.client.replication).DASTStrike(char)
    end)
   
    task.delay(getgenv().EXE_Settings.EXEStrike.Sound2Delay - 0.5, function()
        if getgenv().USE_LONG_MOVES_MID_AIR then
            TweenService:Create(humanoid, TweenInfo.new(0.3, Enum.EasingStyle.Cubic), {HipHeight = 0}):Play()
        end
    end)

    TeleportShot(char, getgenv().EXE_Settings.EXEStrike.TeleportDelay)
    
    Stun(getgenv().EXE_Settings.EXEStrike.StunDuration, false)

    task.delay(getgenv().EXE_Settings.EXEStrike.StunDuration, function()
        pcall(function()
            track:Stop()
        end)
    end)
end

local function OpenMetavision()
    local char = plr.Character
    if not char or Stunned() or IsOnCD("skill4") then return end

    CancelMove()
    DoCD("skill4", getgenv().EXE_Settings.OpenMetavision.Cooldown)

    local humanoid = char.Humanoid
    local root = char.HumanoidRootPart

    for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do track:Stop(0) end

    Stun(0.3, false)

    local screen = Instance.new("ScreenGui", plr.PlayerGui)
    screen.IgnoreGuiInset = true
    local flash = Instance.new("Frame", screen)
    flash.Size = UDim2.fromScale(1, 1)
    flash.BackgroundColor3 = getgenv().EXE_Settings.OpenMetavision.FlashColor
    flash.BackgroundTransparency = 1
    TweenService:Create(flash, TweenInfo.new(0.05), {BackgroundTransparency = 0}):Play()
    task.delay(0.1, function()
        TweenService:Create(flash, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
    end)
    Debris:AddItem(screen, 0.5)

    local sound = Instance.new("Sound")
    sound.SoundId = getgenv().EXE_Settings.OpenMetavision.SoundId
    sound.Volume = getgenv().EXE_Settings.OpenMetavision.SoundVolume
    sound.Parent = root
    sound:Play()
    Debris:AddItem(sound, 4)
end

local function ExeAwk()
    local char = plr.Character
    if not char or Stunned() or exeAwkOnCD then return end

    exeAwkOnCD = true

    local humanoid = char.Humanoid
    local savedStyle = plr:GetAttribute("style")

    Stun(getgenv().EXE_Settings.Awakening.Duration, true)
    plr:SetAttribute("style", "exe")

    if getgenv().Flow_Mid_Air then
        TweenService:Create(humanoid, TweenInfo.new(0.3, Enum.EasingStyle.Cubic), {HipHeight = getgenv().EXE_Settings.Awakening.ElevationHeight}):Play()
    end

    if getgenv().Flow_Chat_lines then
        task.spawn(function()
            task.wait(0.5)
            game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync("So many souls to play with, so little time.")
            task.wait(1.5)
            game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync("Would you agree?")
        end)
    end

    task.spawn(function()
        pcall(function()
            require(rep.util.soundUtil):play(rep.Resources.exe.awkSong, SoundService)
        end)
    end)

    task.spawn(function()
        pcall(function()
            require(rep.util.animationUtil):loadAnimation(char, rep.Resources.exe.awk):Play()
        end)
    end)

    task.spawn(function()
        pcall(function()
            require(rep.client.replication).exeAwk(char)
        end)
    end)

    task.delay(getgenv().EXE_Settings.Awakening.Duration, function()
        if getgenv().Flow_Mid_Air then
            TweenService:Create(humanoid, TweenInfo.new(0.3, Enum.EasingStyle.Cubic), {HipHeight = 0}):Play()
        end
        plr:SetAttribute("style", savedStyle)
        task.delay(getgenv().EXE_Settings.Awakening.Cooldown, function()
            exeAwkOnCD = false
        end)
    end)
end

task.spawn(function()
    while true do
        if stopped then break end
        local gui = plr:WaitForChild("PlayerGui", 2)
        if gui then
            local hotbar = gui:FindFirstChild("Hotbar")
            if hotbar then
                hotbar.MagicHealth.Awakening.Text = "FLOW"
                hotbar.MagicHealth.TextLabel.Text = "Many Souls To Play With."
                hotbar.MagicHealth.Health.Frame.UIGradient.Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 0, 0))
                }

                local backpack = hotbar:FindFirstChild("Backpack")
                if backpack then
                    local hb = backpack:FindFirstChild("Hotbar")
                    if hb then
                        for i = 1, 4 do
                            local skill = hb:FindFirstChild("skill" .. i)
                            if skill and skill:FindFirstChild("Base") and skill.Base:FindFirstChild("ToolName") then
                                if skill.Base.ToolName.Text ~= skillNames[i] then
                                    skill.Base.ToolName.Text = skillNames[i]
                                end
                            end
                            if skill and skill:FindFirstChild("Base") and skill.Base:FindFirstChild("Reuse") then
                                local reuseTexts = {
                                    [1] = "Off The Ball",
                                    [2] = "Trap",
                                    [3] = "Shot",
                                    [4] = "God Mode"
                                }
                                skill.Base.Reuse.Text = reuseTexts[i] or ""
                                skill.Base.Reuse.Visible = true
                            end
                        end
                    end
                end
            end
        end
        task.wait(0.1)
    end
end)

local function Setup(char)
    if stopped then return end
    if not char then return end
    
    repeat task.wait() until plr.Team ~= game.Teams.lobby
    task.wait(0.1)
    
    BlockOriginalSkills()
    plr:SetAttribute("style", "exe")

    local hotbar = plr.PlayerGui:WaitForChild("Hotbar")
    local buttons = hotbar.Backpack.Hotbar

    if buttons.skill1 and buttons.skill1.Base then
        buttons.skill1.Base.MouseButton1Down:Connect(Shortcut)
        buttons.skill1.Base.MouseButton1Click:Connect(Shortcut)
        buttons.skill1.Visible = getgenv().EXE_Settings.Shortcut.Enabled
    end

    if buttons.skill2 and buttons.skill2.Base then
        buttons.skill2.Base.MouseButton1Down:Connect(Exterminate)
        buttons.skill2.Base.MouseButton1Click:Connect(Exterminate)
        buttons.skill2.Visible = getgenv().EXE_Settings.Exterminate.Enabled
    end

    if buttons.skill3 and buttons.skill3.Base then
        buttons.skill3.Base.MouseButton1Down:Connect(EXEStrike)
        buttons.skill3.Base.MouseButton1Click:Connect(EXEStrike)
        buttons.skill3.Visible = getgenv().EXE_Settings.EXEStrike.Enabled
    end

    if buttons.skill4 and buttons.skill4.Base then
        buttons.skill4.Base.MouseButton1Down:Connect(OpenMetavision)
        buttons.skill4.Base.MouseButton1Click:Connect(OpenMetavision)
        buttons.skill4.Visible = getgenv().EXE_Settings.OpenMetavision.Enabled
    end

    if buttons.skill5 then
        buttons.skill5.Visible = false
    end
end

Setup(plr.Character)

plr.CharacterAdded:Connect(function(char)
    exeAwkOnCD = false
    task.wait(1)
    Setup(char)
end)

local function StopMoveset()
    stopped = true
    if watermarkObj and watermarkObj.Parent then watermarkObj:Destroy() end
    
    task.spawn(function()
        local noti = getgenv().
