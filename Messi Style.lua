local plr = game.Players.LocalPlayer
local cam = game.Workspace.CurrentCamera
local rep = game:GetService("ReplicatedStorage")
local remote = rep:WaitForChild("ByteNetReliable")
local messiFolder = rep.Resources.messi
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Debris = game:GetService("Debris")
local Players = game:GetService("Players")
local SoundService = game:GetService("SoundService")

local messiVFX = require(rep.client.replication.otherReplication.messiVFX)
local mainreplication = require(rep.client.replication.mainreplication)
local soundUtil = require(rep.util.soundUtil)

local anims = messiFolder.Animations
local sounds = messiFolder.Sounds

local stopped = false
local flowOnCD = false
local buffers = {}

loadstring(game:HttpGet("https://pastebin.com/raw/8XJh7dzh"))()
repeat task.wait() until game.Lighting:FindFirstChild("BUFFERSTRINGS")
for _, val in ipairs(game.Lighting:FindFirstChild("BUFFERSTRINGS"):GetChildren()) do
    buffers[val.Name] = val.Value
end
game.Lighting:FindFirstChild("BUFFERSTRINGS"):Destroy()

local function DetectExecutor()
    local hasDebug = debug and (debug.getupvalue and debug.setupvalue)
    local hasHook = hookmetamethod
    if hasDebug and hasHook then
        local execName = identifyexecutor and identifyexecutor() or "Executor"
        return true, execName
    else
        local execName = identifyexecutor and identifyexecutor() or "Unknown Executor"
        return false, execName
    end
end

local isFullExecutor, executorName = DetectExecutor()

if not isFullExecutor then
    game.StarterGui:SetCore("SendNotification", {
        Title = "Not Support Executor",
        Text = string.format("%s detected. Use a better executor to run this script.", executorName),
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
        Icon = "rbxassetid://75337362546331"
    })
end

if not getgenv().MessiNotifyGUI then
    getgenv().MessiNotifyGUI = game:GetService('Players').LocalPlayer.PlayerGui.Notification:Clone()
    getgenv().MessiNotifyGUI.Name = string.gsub(tostring(math.random()), '0.', ''):sub(1, 1000) .. string.char(math.random(65, 90), math.random(97, 122), math.random(48, 57))
    getgenv().MessiNotifyGUI.Parent = game.CoreGui
end

task.spawn(function()
    local noti = getgenv().MessiNotifyGUI.Frame.base:Clone()
    noti.Parent = getgenv().MessiNotifyGUI.Frame
    noti.Visible = true
    noti.TextLabel.TextColor3 = Color3.fromRGB(0, 157, 255)
    game.Debris:AddItem(noti, 7.282)
    noti.TextLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    noti.TextLabel.TextStrokeTransparency = 1
    noti.TextLabel.TextTransparency = 1
    noti.TextLabel.Text = "Messi Moveset Loaded!"
    game:GetService('TweenService'):Create(noti, TweenInfo.new(0.28, Enum.EasingStyle.Linear), {Size = UDim2.new(1.33, 0, 0.054, 0)}):Play()
    game:GetService('TweenService'):Create(noti.TextLabel, TweenInfo.new(0.28, Enum.EasingStyle.Linear), {TextTransparency = 0}):Play()
    game:GetService('TweenService'):Create(noti.TextLabel, TweenInfo.new(0.28, Enum.EasingStyle.Linear), {TextStrokeTransparency = 0}):Play()
    task.delay(7, function()
        game:GetService('TweenService'):Create(noti.TextLabel, TweenInfo.new(0.28, Enum.EasingStyle.Linear), {TextTransparency = 1}):Play()
        game:GetService('TweenService'):Create(noti.TextLabel, TweenInfo.new(0.28, Enum.EasingStyle.Linear), {TextStrokeTransparency = 1}):Play()
    end)
end)

task.wait(0.5)
task.spawn(function()
    local noti = getgenv().MessiNotifyGUI.Frame.base:Clone()
    noti.Parent = getgenv().MessiNotifyGUI.Frame
    noti.Visible = true
    noti.TextLabel.TextColor3 = Color3.fromRGB(0, 155, 255)
    game.Debris:AddItem(noti, 7.282)
    noti.TextLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    noti.TextLabel.TextStrokeTransparency = 1
    noti.TextLabel.TextTransparency = 1
    noti.TextLabel.Text = "Made By tze"
    game:GetService('TweenService'):Create(noti, TweenInfo.new(0.28, Enum.EasingStyle.Linear), {Size = UDim2.new(1.33, 0, 0.054, 0)}):Play()
    game:GetService('TweenService'):Create(noti.TextLabel, TweenInfo.new(0.28, Enum.EasingStyle.Linear), {TextTransparency = 0}):Play()
    game:GetService('TweenService'):Create(noti.TextLabel, TweenInfo.new(0.28, Enum.EasingStyle.Linear), {TextStrokeTransparency = 0}):Play()
    task.delay(7, function()
        game:GetService('TweenService'):Create(noti.TextLabel, TweenInfo.new(0.28, Enum.EasingStyle.Linear), {TextTransparency = 1}):Play()
        game:GetService('TweenService'):Create(noti.TextLabel, TweenInfo.new(0.28, Enum.EasingStyle.Linear), {TextStrokeTransparency = 1}):Play()
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
    game:GetService('TweenService'):Create(noti, TweenInfo.new(0.28, Enum.EasingStyle.Linear), {Size = UDim2.new(1.33, 0, 0.054, 0)}):Play()
    game:GetService('TweenService'):Create(noti.TextLabel, TweenInfo.new(0.28, Enum.EasingStyle.Linear), {TextTransparency = 0}):Play()
    game:GetService('TweenService'):Create(noti.TextLabel, TweenInfo.new(0.28, Enum.EasingStyle.Linear), {TextStrokeTransparency = 0}):Play()
    task.delay(5, function()
        game:GetService('TweenService'):Create(noti.TextLabel, TweenInfo.new(0.28, Enum.EasingStyle.Linear), {TextTransparency = 1}):Play()
        game:GetService('TweenService'):Create(noti.TextLabel, TweenInfo.new(0.28, Enum.EasingStyle.Linear), {TextStrokeTransparency = 1}):Play()
    end)
end)

local watermarkObj = nil
if getgenv().MessiWatermarkName == nil or getgenv().MessiWatermarkName == '' then
    getgenv().MessiWatermarkName = string.gsub(tostring(math.random()), '0.', ''):sub(1, 1000) .. string.char(math.random(65, 90), math.random(97, 122), math.random(48, 57))
end
if not game.CoreGui.RobloxGui:FindFirstChild(getgenv().MessiWatermarkName) then
    watermarkObj = getgenv().MessiNotifyGUI.Frame.base.TextLabel:Clone()
    watermarkObj.Text = ' Made By tze '
    watermarkObj.Name = getgenv().MessiWatermarkName
    watermarkObj.Position = UDim2.new(0, 0, -0.02, 0)
    watermarkObj.TextStrokeTransparency = 1
    watermarkObj.TextColor3 = Color3.fromRGB(0, 157, 255)
    watermarkObj.TextTransparency = 0.59
    watermarkObj.Parent = game.CoreGui.RobloxGui
end

local blockedSounds = {
    "rbxassetid://133946857483198",
    "rbxassetid://110043103592232",
    "rbxassetid://89551484323719",
    "rbxassetid://93479045121219",
    "rbxassetid://81199411973051",
    "rbxassetid://81199411973051",
    "rbxassetid://115699700590432",
    "rbxassetid://134456641764445",
}
SoundService.DescendantAdded:Connect(function(sound)
    if sound:IsA("Sound") then
        for _, id in pairs(blockedSounds) do
            if sound.SoundId == id then
                sound:Stop()
                sound:Destroy()
            end
        end
    end
end)

pcall(function()
    local sv = Instance.new("StringValue")
    sv.Name = "Messi"
    sv.Value = "Messi"
    sv.Parent = plr:WaitForChild("storage"):WaitForChild("styles")
end)

local function HasBall()
    return plr.Character and plr.Character:FindFirstChild("Ball")
end

local function Stunned()
    return plr.Character and plr.Character.state.stun.Value
end

local function CancelMove()
    local char = plr.Character
    if char and not char.state.stun.Value then
        char.state.stun.Value = true
        task.wait(0.04)
        char.state.stun.Value = false
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
        task.delay(duration, function() btn.Cooldown.Visible = false end)
    end
end

local function PlaySFX(sound, parent)
    if not sound then return end
    pcall(function() soundUtil:play(sound, parent) end)
end

local function BlockBaseAnimations(humanoid, ourAnimId)
    for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do track:Stop(0) end
    local animBlock = humanoid.AnimationPlayed:Connect(function(track)
        if track.Animation.AnimationId ~= ourAnimId then track:Stop(0) end
    end)
    return animBlock
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

local function Dribble()
    local char = plr.Character
    if not char or Stunned() or not HasBall() or IsOnCD("skill1") then return end
    CancelMove()
    DoCD("skill1", 13)
    local humanoid = char.Humanoid
    local root = char.HumanoidRootPart
    local animBlock = BlockBaseAnimations(humanoid, anims.Dribble.AnimationId)
    humanoid:LoadAnimation(anims.Dribble):Play()
    PlaySFX(sounds.Superstar, root)
    pcall(function() messiVFX.messiDribbleVFX(char, true) end)
    task.delay(4.25, function() animBlock:Disconnect() end)
end

local function Riptide()
    local char = plr.Character
    if not char or Stunned() or not HasBall() or IsOnCD("skill2") then return end
    CancelMove()
    local humanoid = char.Humanoid
    local root = char.HumanoidRootPart
    local animBlock = BlockBaseAnimations(humanoid, anims.Riptide.AnimationId)
    PlaySFX(sounds.Riptide, root)
    pcall(function() messiVFX.messiShootVFX(char) end)
    humanoid:LoadAnimation(anims.Riptide):Play()
    TeleportShot(char, 1.1)
    DoCD("skill2", 8)
    task.delay(1.1, function() animBlock:Disconnect() end)
end

local function SuperPass()
    local char = plr.Character
    if not char or Stunned() or not HasBall() or IsOnCD("skill3") then return end
    local root = char.HumanoidRootPart
    local humanoid = char.Humanoid
    local closestTeammate = nil
    local shortestDistance = 180
    for _, p in ipairs(Players:GetPlayers()) do
        if p == plr then continue end
        if not p.Character then continue end
        if p.Team ~= plr.Team then continue end
        if p.Team == game.Teams.lobby then continue end
        local targetRoot = p.Character:FindFirstChild("HumanoidRootPart")
        if not targetRoot then continue end
        local dist = (root.Position - targetRoot.Position).Magnitude
        if dist < shortestDistance then
            shortestDistance = dist
            closestTeammate = p
        end
    end
    if not closestTeammate then
        CancelMove()
        return
    end
    CancelMove()
    DoCD("skill3", 7)
    local targetRoot = closestTeammate.Character.HumanoidRootPart
    local distance = shortestDistance
    for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do track:Stop(0) end
    humanoid:LoadAnimation(anims.SuperPass):Play()
    pcall(function() messiVFX.messiPassVFX(char) end)
    if sounds:FindFirstChild("Perfect Pass") then
        local s = sounds["Perfect Pass"]:Clone()
        s.Parent = root
        s:Play()
        Debris:AddItem(s, 3)
    end
    task.wait(0.3)
    local direction = (targetRoot.Position - root.Position).Unit
    local kickDir = Vector3.new(direction.X, 0.18, direction.Z).Unit
    local power = math.clamp(distance / 1.4, 18, 95)
    remote:FireServer(
        buffer.fromstring(buffers["base"]),
        { {"kick", power, true, vector.create(kickDir.X, kickDir.Y, kickDir.Z)} }
    )
end

local function Intercept()
    local char = plr.Character
    if not char or IsOnCD("skill4") or Stunned() then return end
    local ball = workspace.Terrain:FindFirstChild("Ball")
    if not ball then return end
    local humanoid = char.Humanoid
    local root = char.HumanoidRootPart
    local dist = (root.Position - ball.Position).Magnitude
    if dist > 300 then return end
    CancelMove()
    DoCD("skill4", 4)
    humanoid:LoadAnimation(anims.InterceptStart):Play()
    pcall(function() 
        local s = Instance.new("Sound")
        s.SoundId = "rbxassetid://89339537870505"
        s.Volume = 1
        s.Parent = root
        s:Play()
        Debris:AddItem(s, 3)
    end)
    pcall(function() messiVFX.messiInterceptStart(char) end)
    humanoid.HipHeight = 10
    task.wait(0.3)
    for _ = 1, 9 do
        remote:FireServer(buffer.fromstring(buffers["grabball"]))
        task.wait(0.05)
        if HasBall() then break end
    end
    TweenService:Create(humanoid, TweenInfo.new(0.4, Enum.EasingStyle.Cubic), {HipHeight = 0}):Play()
    if HasBall() then
        root.Anchored = true
        root.AssemblyLinearVelocity = Vector3.zero
        humanoid.AutoRotate = false
        for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do track:Stop(0) end
        local animBlock = BlockBaseAnimations(humanoid, anims.Intercept.AnimationId)
        humanoid:LoadAnimation(anims.Intercept):Play()
        PlaySFX(sounds.TrapCutscene, root)
        pcall(function() messiVFX.messiInterceptCutscene(char) end)
        task.wait(0.8)
        root.Anchored = false
        root.AssemblyLinearVelocity = Vector3.new(0, -100, 0)
        humanoid.AutoRotate = true
        task.delay(2.5, function() animBlock:Disconnect(); mainreplication.sceneEnabled(false) end)
    else
        char.state.stun.Value = true
        task.delay(1.5, function() char.state.stun.Value = false end)
    end
end

local function HeadsUpShot()
    local char = plr.Character
    if not char or Stunned() or not HasBall() or IsOnCD("skill4") then return end
    CancelMove()
    local humanoid = char.Humanoid
    local root = char.HumanoidRootPart
    local animBlock = BlockBaseAnimations(humanoid, anims.InterceptShot.AnimationId)
    PlaySFX(sounds.TrapShot, root)
    pcall(function() messiVFX.messiShootVFX(char) end)
    humanoid:LoadAnimation(anims.InterceptShot):Play()
    pcall(function() messiVFX.messiInterceptShot(char) end)
    TeleportShot(char, 2.3)
    DoCD("skill4", 15)
    task.delay(2.9, function() animBlock:Disconnect() end)
end

local function Skill4()
    if HasBall() then
        HeadsUpShot()
    else
        Intercept()
    end
end

local function NutmegSteal()
    local char = plr.Character
    if not char or Stunned() or IsOnCD("skill5") then return end
    if HasBall() then return end
    local root = char.HumanoidRootPart
    if not root then return end
    local humanoid = char.Humanoid
    if not humanoid then return end
    local closestEnemyWithBall = nil
    local shortestDistance = 35
    for _, p in ipairs(Players:GetPlayers()) do
        if p == plr then continue end
        if not p.Character then continue end
        if p.Team == plr.Team then continue end
        if p.Team == game.Teams.lobby then continue end
        if not p.Character:FindFirstChild("Ball") then continue end
        local targetRoot = p.Character:FindFirstChild("HumanoidRootPart")
        if not targetRoot then continue end
        local dist = (root.Position - targetRoot.Position).Magnitude
        if dist < shortestDistance then
            shortestDistance = dist
            closestEnemyWithBall = p
        end
    end
    if not closestEnemyWithBall then
        CancelMove()
        DoCD("skill5", 13)
        for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do track:Stop(0) end
        local animTackle = humanoid:LoadAnimation(anims.NutmegStart)
        if animTackle then animTackle:Play() end
        PlaySFX(sounds.NutmegUse, root)
        local animBlock = humanoid.AnimationPlayed:Connect(function(track)
            if track.Animation.AnimationId == "rbxassetid://109744655458082" then track:Stop(0) end
        end)
        task.wait(0.5)
        remote:FireServer(buffer.fromstring(buffers["base"]), {{"tackle"}})
        task.wait(0.3)
        animBlock:Disconnect()
        if HasBall() then
            for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do track:Stop(0) end
            local animHit = humanoid:LoadAnimation(anims.NutmegHitUser)
            if animHit then animHit:Play() end
            PlaySFX(sounds.NutmegHit, root)
            pcall(function() messiVFX.messiNutmeg(char) end)
            local bv = Instance.new("BodyVelocity")
            bv.MaxForce = Vector3.new(math.huge, 0, math.huge)
            bv.Velocity = root.CFrame.LookVector * 150
            bv.Parent = root
            Debris:AddItem(bv, 0.5)
        else
            char.state.stun.Value = true
            task.delay(0.5, function()
                if char and char.state then char.state.stun.Value = false end
            end)
        end
        return
    end
    local targetRoot = closestEnemyWithBall.Character.HumanoidRootPart
    if not targetRoot then return end
    CancelMove()
    DoCD("skill5", 13)
    local behindPos = targetRoot.CFrame * CFrame.new(0, 0, 5)
    root.CFrame = CFrame.new(behindPos.Position, targetRoot.Position)
    for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do track:Stop(0) end
    local animTackle = humanoid:LoadAnimation(anims.NutmegStart)
    if animTackle then animTackle:Play() end
    PlaySFX(sounds.NutmegUse, root)
    local animBlock = humanoid.AnimationPlayed:Connect(function(track)
        if track.Animation.AnimationId == "rbxassetid://109744655458082" then track:Stop(0) end
    end)
    task.wait(0.08)
    remote:FireServer(buffer.fromstring(buffers["base"]), {{"tackle"}})
    task.wait(0.3)
    animBlock:Disconnect()
    if HasBall() then
        for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do track:Stop(0) end
        local animHit = humanoid:LoadAnimation(anims.NutmegHitUser)
        if animHit then animHit:Play() end
        PlaySFX(sounds.NutmegHit, root)
        pcall(function() messiVFX.messiNutmeg(char) end)
        local bv = Instance.new("BodyVelocity")
        bv.MaxForce = Vector3.new(math.huge, 0, math.huge)
        bv.Velocity = root.CFrame.LookVector * 150
        bv.Parent = root
        Debris:AddItem(bv, 0.5)
    else
        char.state.stun.Value = true
        task.delay(0.5, function()
            if char and char.state then char.state.stun.Value = false end
        end)
    end
end

local function MessiFlow()
    local char = plr.Character
    if not char or Stunned() then return end
    if not HasBall() then return end
    if flowOnCD then return end
    flowOnCD = true
    task.wait(0.5)
    local timer = rep.workspace.timer
    local isOvertime = (timer.Value <= 0)
    local songDuration = 60
    if isOvertime then
        local song = Instance.new("Sound")
        song.SoundId = "rbxassetid://83926637345099"
        song.Parent = SoundService
        song:Play()
        songDuration = song.TimeLength > 0 and song.TimeLength or 90
    else
        if sounds.Themes and sounds.Themes:FindFirstChild("Normal") then
            local song = sounds.Themes.Normal
            songDuration = song.TimeLength > 0 and song.TimeLength or 60
            soundUtil:play(song, SoundService)
        end
    end
    pcall(function() messiVFX.messiFlow(char) end)
    if anims:FindFirstChild("Flow") then
        for _, track in pairs(char.Humanoid:GetPlayingAnimationTracks()) do track:Stop(0) end
        char.Humanoid:LoadAnimation(anims.Flow):Play()
    end
    task.delay(songDuration, function() flowOnCD = false end)
end

local function Setup(char)
    if stopped then return end
    repeat task.wait() until plr.Team ~= game.Teams.lobby
    task.wait(0.1)
    plr:SetAttribute("style", "messi")
    local hotbar = plr.PlayerGui:WaitForChild("Hotbar")
    local buttons = hotbar.Backpack.Hotbar
    buttons.skill1.Base.MouseButton1Down:Connect(Dribble)
    buttons.skill2.Base.MouseButton1Down:Connect(Riptide)
    buttons.skill3.Base.MouseButton1Down:Connect(SuperPass)
    buttons.skill4.Base.MouseButton1Down:Connect(Skill4)
    buttons.skill5.Base.MouseButton1Down:Connect(NutmegSteal)
    buttons.skill1.Base.MouseButton1Click:Connect(Dribble)
    buttons.skill2.Base.MouseButton1Click:Connect(Riptide)
    buttons.skill3.Base.MouseButton1Click:Connect(SuperPass)
    buttons.skill4.Base.MouseButton1Click:Connect(Skill4)
    buttons.skill5.Base.MouseButton1Click:Connect(NutmegSteal)
    buttons.skill1.Base.ToolName.Text = "Superstar"
    buttons.skill2.Base.ToolName.Text = "Riptide"
    buttons.skill3.Base.ToolName.Text = "Super Pass"
    buttons.skill4.Base.ToolName.Text = "Heads Up"
    buttons.skill5.Base.ToolName.Text = "Forced Nutmeg"
    buttons.skill1.Base.Reuse.Text = "Ball only"
    buttons.skill2.Base.Reuse.Text = "ball only"
    buttons.skill3.Base.Reuse.Text = "Auto-Pass"
    buttons.skill4.Base.Reuse.Text = ""
    buttons.skill5.Base.Reuse.Text = "Steal"
    for i = 1, 5 do 
        buttons["skill"..i].Base.Reuse.Visible = true
        buttons["skill"..i].Visible = true
    end
    hotbar.MagicHealth.Awakening.Text = "The Goat."
    hotbar.MagicHealth.TextLabel.Text = "Argentina's Best."
    hotbar.MagicHealth.Health.Frame.UIGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 157, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 157, 255))
    }
    char:GetAttributeChangedSignal("FlowActive"):Connect(function()
        if char:GetAttribute("FlowActive") == true and not stopped then
            char:SetAttribute("FlowActive", false)
            MessiFlow()
        end
    end)
end

Setup(plr.Character)
plr.CharacterAdded:Connect(function(char)
    flowOnCD = false
    task.wait(1)
    Setup(char)
end)

local function StopMoveset()
    stopped = true
    if watermarkObj and watermarkObj.Parent then
        watermarkObj:Destroy()
    end
    task.spawn(function()
        local noti = getgenv().MessiNotifyGUI.Frame.base:Clone()
        noti.Parent = getgenv().MessiNotifyGUI.Frame
        noti.Visible = true
        noti.TextLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
        game.Debris:AddItem(noti, 5.282)
        noti.TextLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        noti.TextLabel.TextStrokeTransparency = 1
        noti.TextLabel.TextTransparency = 1
        noti.TextLabel.Text = "Messi Moveset Stopped!"
        game:GetService('TweenService'):Create(noti, TweenInfo.new(0.28, Enum.EasingStyle.Linear), {Size = UDim2.new(1.33, 0, 0.054, 0)}):Play()
        game:GetService('TweenService'):Create(noti.TextLabel, TweenInfo.new(0.28, Enum.EasingStyle.Linear), {TextTransparency = 0}):Play()
        game:GetService('TweenService'):Create(noti.TextLabel, TweenInfo.new(0.28, Enum.EasingStyle.Linear), {TextStrokeTransparency = 0}):Play()
        task.delay(5, function()
            game:GetService('TweenService'):Create(noti.TextLabel, TweenInfo.new(0.28, Enum.EasingStyle.Linear), {TextTransparency = 1}):Play()
            game:GetService('TweenService'):Create(noti.TextLabel, TweenInfo.new(0.28, Enum.EasingStyle.Linear), {TextStrokeTransparency = 1}):Play()
        end)
    end)
end

UserInputService.InputBegan:Connect(function(input, bg)
    if bg or stopped then return end
    if input.KeyCode == Enum.KeyCode.One then Dribble()
    elseif input.KeyCode == Enum.KeyCode.Two then Riptide()
    elseif input.KeyCode == Enum.KeyCode.Three then SuperPass()
    elseif input.KeyCode == Enum.KeyCode.Four then Skill4()
    elseif input.KeyCode == Enum.KeyCode.Five then NutmegSteal()
    elseif input.KeyCode == Enum.KeyCode.G then MessiFlow()
    elseif input.KeyCode == Enum.KeyCode.F4 then StopMoveset()
    elseif input.KeyCode == Enum.KeyCode.F5 then
        if watermarkObj and watermarkObj.Parent then
            watermarkObj:Destroy()
        end
    end
end)

print("Messi Moveset loaded!")
