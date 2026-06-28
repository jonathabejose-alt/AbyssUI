local plr = game.Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local SoundService = game:GetService("SoundService")
local Debris = game:GetService("Debris")

local CONFIG = {
    StartAnimation = "rbxassetid://74358763366120",
    LoopAnimation = "rbxassetid://94915955533070",
    StartSound = "rbxassetid://118415112024805",
    LoopSound = "rbxassetid://127575451203432",
    StartDuration = 6.7,
    LoopSoundInterval = 5.1,
    Volume = 2.5
}

local emoteActive = false
local cleanupTasks = {}

local function cleanup()
    for _, task in ipairs(cleanupTasks) do
        pcall(function()
            if typeof(task) == "thread" then
                task:cancel()
            elseif typeof(task) == "RBXScriptConnection" then
                task:Disconnect()
            elseif typeof(task) == "Instance" then
                task:Destroy()
            end
        end)
    end
    cleanupTasks = {}
    emoteActive = false
end

local function safeCleanup(instance)
    if instance and instance.Parent then
        pcall(function() 
            instance:Stop()
            instance:Destroy()
        end)
    end
end

local function StopEmote()
    cleanup()
end

local function PlayLoopSound(character)
    if not emoteActive or not character or not character.Parent then return end
    
    local soundLoop = Instance.new("Sound")
    soundLoop.SoundId = CONFIG.LoopSound
    soundLoop.Parent = character
    soundLoop.Volume = CONFIG.Volume
    soundLoop:Play()
    
    table.insert(cleanupTasks, soundLoop)
    
    task.delay(CONFIG.LoopSoundInterval, function()
        safeCleanup(soundLoop)
    end)
    
    if emoteActive then
        local delayThread = task.delay(CONFIG.LoopSoundInterval, function()
            PlayLoopSound(character)
        end)
        table.insert(cleanupTasks, delayThread)
    end
end

local function PlayEmote()
    local char = plr.Character
    if not char then return end
    
    local humanoid = char:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    StopEmote()
    emoteActive = true
    
    for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
        pcall(function() track:Stop() end)
    end
    
    local animStart = Instance.new("Animation")
    animStart.AnimationId = CONFIG.StartAnimation
    local animTrackStart = humanoid:LoadAnimation(animStart)
    if animTrackStart then
        animTrackStart:Play()
        table.insert(cleanupTasks, animTrackStart)
    end
    animStart:Destroy()
    
    local soundStart = Instance.new("Sound")
    soundStart.SoundId = CONFIG.StartSound
    soundStart.Parent = char
    soundStart.Volume = CONFIG.Volume
    soundStart:Play()
    table.insert(cleanupTasks, soundStart)
    
    local soundCleanupThread = task.delay(CONFIG.StartDuration + 0.5, function()
        safeCleanup(soundStart)
    end)
    table.insert(cleanupTasks, soundCleanupThread)
    
    local transitionThread = task.delay(CONFIG.StartDuration, function()
        if not emoteActive then return end
        
        if animTrackStart then
            pcall(function() animTrackStart:Stop() end)
        end
        
        local animLoop = Instance.new("Animation")
        animLoop.AnimationId = CONFIG.LoopAnimation
        local animTrackLoop = humanoid:LoadAnimation(animLoop)
        if animTrackLoop then
            animTrackLoop:Play()
            table.insert(cleanupTasks, animTrackLoop)
        end
        animLoop:Destroy()
        
        PlayLoopSound(char)
    end)
    table.insert(cleanupTasks, transitionThread)
end

local inputConn = UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.C then
        PlayEmote()
    elseif input.KeyCode == Enum.KeyCode.X then
        StopEmote()
    elseif input.KeyCode == Enum.KeyCode.F4 then
        StopEmote()
        inputConn:Disconnect()
        charConn:Disconnect()
    end
end)

local charConn = plr.CharacterAdded:Connect(function(character)
    StopEmote()
    
    local humanoid = character:WaitForChild("Humanoid")
    if humanoid then
        humanoid.Died:Connect(function()
            StopEmote()
        end)
    end
end)
