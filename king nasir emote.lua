local plr = game.Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

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
local cleanupObjects = {}
local scriptActive = true 

local function cleanupEmote()
    emoteActive = false
    
    for _, obj in ipairs(cleanupObjects) do
        pcall(function()
            if typeof(obj) == "thread" then
                task.cancel(obj)
            elseif typeof(obj) == "RBXScriptConnection" then
                obj:Disconnect()
            elseif typeof(obj) == "Instance" then
                if obj:IsA("Sound") or obj:IsA("AnimationTrack") then
                    obj:Stop()
                end
                obj:Destroy()
            end
        end)
    end
    
    table.clear(cleanupObjects)

    local char = plr.Character
    if char then
        local humanoid = char:FindFirstChild("Humanoid")
        if humanoid then
            for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
                pcall(function()
                    track:Stop(0)
                end)
            end
        end
    end
end

local function destroyScript()
    cleanupEmote()
    scriptActive = false
    
    if inputConnection then
        inputConnection:Disconnect()
        inputConnection = nil
    end
    
    if characterConnection then
        characterConnection:Disconnect()
        characterConnection = nil
    end
    
    if deathConnection then
        deathConnection:Disconnect()
        deathConnection = nil
    end

    script:Destroy()
end

local function stopEmote()
    if emoteActive then
        cleanupEmote()
    end
end

local function playLoopSound(character)
    if not emoteActive or not character or not character:IsDescendantOf(workspace) then 
        return 
    end
    
    local sound = Instance.new("Sound")
    sound.SoundId = CONFIG.LoopSound
    sound.Volume = CONFIG.Volume
    sound.Parent = character
    sound:Play()
    
    table.insert(cleanupObjects, sound)
    
    local nextLoopThread = task.delay(CONFIG.LoopSoundInterval, function()
        if emoteActive then
            playLoopSound(character)
        end
    end)
    table.insert(cleanupObjects, nextLoopThread)
end

local function playEmote()
    if not scriptActive then return end
    
    local char = plr.Character
    if not char then return end
    
    local humanoid = char:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    cleanupEmote()
    emoteActive = true

    local startAnim = Instance.new("Animation")
    startAnim.AnimationId = CONFIG.StartAnimation
    local startTrack = humanoid:LoadAnimation(startAnim)
    
    if startTrack then
        startTrack:Play()
        table.insert(cleanupObjects, startTrack)
    end
    startAnim:Destroy()
    
    local startSound = Instance.new("Sound")
    startSound.SoundId = CONFIG.StartSound
    startSound.Volume = CONFIG.Volume
    startSound.Parent = char
    startSound:Play()
    table.insert(cleanupObjects, startSound)
    
    local transitionThread = task.delay(CONFIG.StartDuration, function()
        if not emoteActive then return end
        
        if startTrack then
            startTrack:Stop(0)
        end
        
        local loopAnim = Instance.new("Animation")
        loopAnim.AnimationId = CONFIG.LoopAnimation
        local loopTrack = humanoid:LoadAnimation(loopAnim)
        
        if loopTrack then
            loopTrack:Play()
            table.insert(cleanupObjects, loopTrack)
        end
        loopAnim:Destroy()
        
        playLoopSound(char)
    end)
    table.insert(cleanupObjects, transitionThread)
end

local inputConnection
local characterConnection
local deathConnection

inputConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not scriptActive then return end
    
    if input.KeyCode == Enum.KeyCode.X then
        stopEmote()
        return
    end
    
    if input.KeyCode == Enum.KeyCode.C and not gameProcessed then
        playEmote()
        return
    end
    if input.KeyCode == Enum.KeyCode.F4 then
        destroyScript()
    end
end)

characterConnection = plr.CharacterAdded:Connect(function(character)
    if not scriptActive then return end
    
    stopEmote()
    
    local humanoid = character:WaitForChild("Humanoid")
    if humanoid then
        if deathConnection then
            deathConnection:Disconnect()
        end
        
        deathConnection = humanoid.Died:Connect(function()
            if scriptActive then
                stopEmote()
            end
        end)
    end
end)
