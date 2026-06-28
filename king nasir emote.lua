local plr = game.Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

local CONFIG = {
    StartAnimation = "rbxassetid://74358763366120",
    LoopAnimation = "rbxassetid://94915955533070",
    StartSound = "rbxassetid://118415112024805",
    LoopSound = "rbxassetid://127575451203432",
    StartDuration = 6.7,
    StartVolume = 2.5,
    LoopVolume = 5
}

local loopSoundDuration = 7.050

local emoteActive = false
local cleanupObjects = {}
local scriptActive = true 
local currentSounds = {}
local inputConnection
local characterConnection
local deathConnection

local function cleanupEmote()
    emoteActive = false
    
    for _, sound in ipairs(currentSounds) do
        pcall(function()
            sound:Stop()
            sound:Destroy()
        end)
    end
    table.clear(currentSounds)
    
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
    scriptActive = false
    cleanupEmote()
    
    if deathConnection then
        deathConnection:Disconnect()
        deathConnection = nil
    end
    
    if characterConnection then
        characterConnection:Disconnect()
        characterConnection = nil
    end
    
    if inputConnection then
        inputConnection:Disconnect()
        inputConnection = nil
    end

    script:Destroy()
end

local function stopEmote()
    cleanupEmote()
end

local function playLoopSound(character)
    if not emoteActive or not character or not character:IsDescendantOf(workspace) then 
        return 
    end
    
    local function createAndPlay()
        if not emoteActive or not character:IsDescendantOf(workspace) then return end
        
        local sound = Instance.new("Sound")
        sound.SoundId = CONFIG.LoopSound
        sound.Volume = CONFIG.LoopVolume
        sound.Parent = character
        sound:Play()
        
        table.insert(currentSounds, sound)
        
        local nextThread = task.delay(loopSoundDuration - 0.05, function()
            if emoteActive then
                createAndPlay()
            end
        end)
        table.insert(cleanupObjects, nextThread)
        
        local cleanupThread = task.delay(loopSoundDuration + 0.1, function()
            for i, s in ipairs(currentSounds) do
                if s == sound then
                    table.remove(currentSounds, i)
                    break
                end
            end
            if sound and sound.Parent then
                sound:Destroy()
            end
        end)
        table.insert(cleanupObjects, cleanupThread)
    end
    
    createAndPlay()
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
    startSound.Volume = CONFIG.StartVolume
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

inputConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not scriptActive then return end
    
    if input.KeyCode == Enum.KeyCode.X then
        stopEmote()
    elseif input.KeyCode == Enum.KeyCode.C then
        if not gameProcessed then
            playEmote()
        end
    elseif input.KeyCode == Enum.KeyCode.F4 then
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
