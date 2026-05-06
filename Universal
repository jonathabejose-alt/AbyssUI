-- ✦ Ultimate Hub | WindUI Boreal Port | By Em_Jay225
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/x7dJJ9vnFH23/WindUI-Boreal/refs/heads/main/WindUI%20Boreal

-- ==================== DEVICE CHECK ====================
local UserInputService = game:GetService("UserInputService")
if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
    game:GetService("Players").LocalPlayer:Kick("(PC Only)")
    return
end

-- ==================== WINDOW ====================
local Window = WindUI:CreateWindow({
    Title   = "✦ Abyss Ui universal",
    Author  = "Tze",
    Folder  = "UltimateHub",
    Icon    = "star",
    Theme   = "Midnight",
    Size    = UDim2.fromOffset(720, 540),
    Transparent  = true,
    Acrylic      = false,
    SideBarWidth = 210,
    ScrollBarEnabled = true,
    HideSearchBar    = false,
    Resizable        = true,
    ModernLayout     = true,

    Topbar = {
        Height      = 52,
        ButtonsType = "Default",
    },

    OpenButton = {
        Enabled    = true,
        Title      = "abyss Hub",
        Icon       = "star",
        Position   = UDim2.new(0, 120, 0, 120),
        Draggable  = true,
        OnlyMobile = false,
        Scale      = 1,
    },

    Watermark = {
        Enabled  = true,
        Text     = "✦ abyss ui",
        Position = "bottom-right",
        Opacity  = 0.45,
        Size     = 13,
    },
})

Window:BindShortcut("RightAlt", function()
    Window:Toggle()
end, {
    Description      = "Toggle Ultimate Hub",
    EnabledWhenClosed = true,
})

Window:Tag({
    Title = "v1",
    Color = Color3.fromRGB(248, 155, 41),
    Icon  = "badge-check",
})

Window:SetBackgroundImage("rbxassetid://132996641534150")
Window:ToggleTransparency(true)

-- ==================== SERVICES ====================
local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local TeleportService  = game:GetService("TeleportService")
local HttpService      = game:GetService("HttpService")
local Lighting         = game:GetService("Lighting")

local player    = Players.LocalPlayer
local camera    = workspace.CurrentCamera
local character = player.Character or player.CharacterAdded:Wait()
local humanoid  = character:WaitForChild("Humanoid")
local rootPart  = character:WaitForChild("HumanoidRootPart")

local function notify(title, content, icon, duration)
    WindUI:Notify({
        Title    = title,
        Content  = content,
        Icon     = icon or "info",
        Duration = duration or 3,
    })
end

-- ==================== STATES ====================
local flyEnabled      = false
local flySpeed        = 50
local noclipEnabled   = false
local airwalkEnabled  = false
local infJumpEnabled  = false
local fullbright      = false
local antiAfkEnabled  = false
local espColor        = Color3.fromRGB(255, 60, 60)
local espHighlight    = false
local espTracers      = false
local espBoxes        = false
local espNames        = false
local espHealth       = false
local espDistance     = false
local teamCheck       = false

local aimbotEnabled   = false
local aimWallCheck    = false
local aimTeamCheck    = false
local aimFovRadius    = 100
local aimShowFov      = false
local aimRgbFov       = false
local aimToggleRmb    = false
local aimSmoothness   = 1

local flyConnection      = nil
local noclipConnection   = nil
local airwalkConnection  = nil
local airwalkPart        = nil
local originalCollisions = {}
local antiAfkConnection  = nil

local origAmbient       = Lighting.Ambient
local origBrightness    = Lighting.Brightness
local origClockTime     = Lighting.ClockTime
local origFogEnd        = Lighting.FogEnd
local origGlobalShadows = Lighting.GlobalShadows
local origGravity       = workspace.Gravity

-- ==================== CHARACTER RESPAWN ====================
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoid  = newChar:WaitForChild("Humanoid")
    rootPart  = newChar:WaitForChild("HumanoidRootPart")
    humanoid.WalkSpeed = 16
    humanoid.JumpPower = 50
end)

-- ==================== FLY ====================
local function startFly()
    if flyConnection then flyConnection:Disconnect() end
    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
    bv.Velocity = Vector3.zero
    bv.Parent   = rootPart
    local bg = Instance.new("BodyGyro")
    bg.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
    bg.D = 100
    bg.Parent = rootPart
    humanoid.PlatformStand = true
    flyConnection = RunService.RenderStepped:Connect(function()
        if not flyEnabled then
            bv:Destroy(); bg:Destroy()
            if humanoid then humanoid.PlatformStand = false end
            flyConnection:Disconnect(); flyConnection = nil
            return
        end
        local cf  = camera.CFrame
        local dir = Vector3.zero
        if UserInputService:IsKeyDown(Enum.KeyCode.W)         then dir += cf.LookVector              end
        if UserInputService:IsKeyDown(Enum.KeyCode.S)         then dir -= cf.LookVector              end
        if UserInputService:IsKeyDown(Enum.KeyCode.A)         then dir -= cf.RightVector             end
        if UserInputService:IsKeyDown(Enum.KeyCode.D)         then dir += cf.RightVector             end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space)     then dir += Vector3.new(0, 1, 0)       end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then dir -= Vector3.new(0, 1, 0)       end
        bv.Velocity = dir.Magnitude > 0 and dir.Unit * flySpeed or Vector3.zero
        bg.CFrame   = cf
    end)
end

-- ==================== NOCLIP ====================
local function enableNoclip()
    if noclipConnection then noclipConnection:Disconnect() end
    originalCollisions = {}
    if character then
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then originalCollisions[part] = part.CanCollide end
        end
    end
    noclipConnection = RunService.Stepped:Connect(function()
        if not noclipEnabled or not character then return end
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end)
end

local function disableNoclip()
    if noclipConnection then noclipConnection:Disconnect(); noclipConnection = nil end
    if character then
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                if part.Name == "HumanoidRootPart" then
                    part.CanCollide = false
                elseif originalCollisions[part] ~= nil then
                    part.CanCollide = originalCollisions[part]
                else
                    part.CanCollide = true
                end
            end
        end
    end
    originalCollisions = {}
end

-- ==================== AIRWALK ====================
local function enableAirwalk()
    if airwalkPart then airwalkPart:Destroy() end
    airwalkPart             = Instance.new("Part")
    airwalkPart.Size        = Vector3.new(3.5, 0.05, 3.5)
    airwalkPart.Anchored    = true
    airwalkPart.CanCollide  = true
    airwalkPart.Transparency = 1
    airwalkPart.CanTouch    = false
    airwalkPart.Name        = "AirwalkPlatform"
    airwalkPart.Material    = Enum.Material.SmoothPlastic
    airwalkPart.Parent      = workspace
    local lockedY = rootPart.Position.Y - 2.9
    airwalkPart.CFrame = CFrame.new(rootPart.Position.X, lockedY, rootPart.Position.Z)
    airwalkConnection = RunService.Heartbeat:Connect(function()
        if not airwalkEnabled or not rootPart then
            if airwalkPart then airwalkPart:Destroy(); airwalkPart = nil end
            if airwalkConnection then airwalkConnection:Disconnect(); airwalkConnection = nil end
            return
        end
        local pos    = rootPart.Position
        local floorY = pos.Y - 2.9
        if floorY < lockedY then lockedY = floorY end
        airwalkPart.CFrame = CFrame.new(pos.X, lockedY, pos.Z)
    end)
end

local function disableAirwalk()
    airwalkEnabled = false
    if airwalkConnection then airwalkConnection:Disconnect(); airwalkConnection = nil end
    if airwalkPart then airwalkPart:Destroy(); airwalkPart = nil end
end

-- ==================== INFINITE JUMP ====================
UserInputService.JumpRequest:Connect(function()
    if infJumpEnabled and humanoid then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- ==================== FULLBRIGHT ====================
local fullBrightConn = nil

local function enableFullbright()
    Lighting.Ambient       = Color3.fromRGB(255, 255, 255)
    Lighting.Brightness    = 2
    Lighting.ClockTime     = 14
    Lighting.FogEnd        = 100000
    Lighting.GlobalShadows = false
    if fullBrightConn then fullBrightConn:Disconnect() end
    fullBrightConn = RunService.Heartbeat:Connect(function()
        Lighting.Ambient       = Color3.fromRGB(255, 255, 255)
        Lighting.Brightness    = 2
        Lighting.ClockTime     = 14
        Lighting.FogEnd        = 100000
        Lighting.GlobalShadows = false
    end)
end

local function disableFullbright()
    if fullBrightConn then fullBrightConn:Disconnect(); fullBrightConn = nil end
    Lighting.Ambient       = origAmbient
    Lighting.Brightness    = origBrightness
    Lighting.ClockTime     = origClockTime
    Lighting.FogEnd        = origFogEnd
    Lighting.GlobalShadows = origGlobalShadows
end

-- ==================== ANTI AFK ====================
local function enableAntiAfk()
    if antiAfkConnection then antiAfkConnection:Disconnect() end
    local afkTimer = 0
    antiAfkConnection = RunService.Heartbeat:Connect(function(dt)
        afkTimer += dt
        if afkTimer >= 60 then
            afkTimer = 0
            player:Move(Vector3.new(0, 0, 0), false)
        end
    end)
end

local function disableAntiAfk()
    if antiAfkConnection then antiAfkConnection:Disconnect(); antiAfkConnection = nil end
end

-- ==================== AIMBOT ====================
local fovCircle = Drawing.new("Circle")
fovCircle.Thickness    = 1
fovCircle.NumSides     = 100
fovCircle.Filled       = false
fovCircle.Transparency = 1
fovCircle.Color        = Color3.fromRGB(255, 255, 255)

local function getClosestPlayer()
    local closestPlayer   = nil
    local shortestDistance = math.huge
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= player and v.Character and v.Character:FindFirstChild("Humanoid")
           and v.Character.Humanoid.Health > 0 and v.Character:FindFirstChild("Head") then
            if aimTeamCheck and v.Team == player.Team then continue end
            local headPos, onScreen = camera:WorldToViewportPoint(v.Character.Head.Position)
            if onScreen then
                local mousePos = UserInputService:GetMouseLocation()
                local distance = (Vector2.new(headPos.X, headPos.Y) - mousePos).Magnitude
                if distance <= aimFovRadius and distance < shortestDistance then
                    if aimWallCheck then
                        local parts = camera:GetPartsObscuringTarget({v.Character.Head.Position}, {character, v.Character})
                        if #parts == 0 then closestPlayer = v; shortestDistance = distance end
                    else
                        closestPlayer = v; shortestDistance = distance
                    end
                end
            end
        end
    end
    return closestPlayer
end

RunService.RenderStepped:Connect(function()
    fovCircle.Visible  = aimShowFov
    fovCircle.Radius   = aimFovRadius
    fovCircle.Position = UserInputService:GetMouseLocation()
    fovCircle.Color    = aimRgbFov and Color3.fromHSV(tick() % 5 / 5, 1, 1) or Color3.fromRGB(255, 255, 255)

    if aimbotEnabled then
        local isRmb = UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
        if (aimToggleRmb and isRmb) or not aimToggleRmb then
            local target = getClosestPlayer()
            if target and target.Character and target.Character:FindFirstChild("Head") then
                local targetCF = CFrame.new(camera.CFrame.Position, target.Character.Head.Position)
                camera.CFrame  = camera.CFrame:Lerp(targetCF, 1 / aimSmoothness)
            end
        end
    end
end)

-- ==================== ESP ====================
local highlights     = {}
local playerDrawings = {}

local function isSameTeam(targetPlayer)
    if not teamCheck then return false end
    if player.Team ~= nil and targetPlayer.Team ~= nil then return player.Team == targetPlayer.Team end
    if player.TeamColor and targetPlayer.TeamColor then return player.TeamColor == targetPlayer.TeamColor end
    return false
end

local function removeHighlight(targetPlayer)
    if highlights[targetPlayer] then highlights[targetPlayer]:Destroy(); highlights[targetPlayer] = nil end
end

local function removeDrawings(targetPlayer)
    if playerDrawings[targetPlayer] then
        for _, d in pairs(playerDrawings[targetPlayer]) do pcall(function() d:Remove() end) end
        playerDrawings[targetPlayer] = nil
    end
end

local function getDrawings(targetPlayer)
    if not playerDrawings[targetPlayer] then
        local function newLine()
            local l = Drawing.new("Line"); l.Color = espColor; l.Thickness = 1.5; l.Visible = false; return l
        end
        local function newText(size, color)
            local t = Drawing.new("Text"); t.Size = size; t.Color = color
            t.Outline = true; t.Center = true; t.Visible = false; t.Font = 2; return t
        end
        playerDrawings[targetPlayer] = {
            tracer   = newLine(),
            boxT     = newLine(), boxB = newLine(), boxL = newLine(), boxR = newLine(),
            name     = newText(13, Color3.fromRGB(255, 255, 255)),
            health   = newText(12, Color3.fromRGB(50, 255, 100)),
            distance = newText(11, Color3.fromRGB(200, 200, 200)),
        }
    end
    return playerDrawings[targetPlayer]
end

local function updateAllDrawingColors()
    for _, d in pairs(playerDrawings) do
        for _, key in ipairs({"tracer","boxT","boxB","boxL","boxR"}) do
            if d[key] then d[key].Color = espColor end
        end
    end
    for _, h in pairs(highlights) do h.FillColor = espColor end
end

RunService.RenderStepped:Connect(function()
    for _, target in ipairs(Players:GetPlayers()) do
        if target == player then continue end
        local char   = target.Character
        local tRoot  = char and char:FindFirstChild("HumanoidRootPart")
        local tHum   = char and char:FindFirstChildOfClass("Humanoid")
        local alive  = tHum and tHum.Health > 0
        local sameT  = isSameTeam(target)

        if espHighlight and char and alive and not sameT then
            if not highlights[target] then
                local h = Instance.new("Highlight")
                h.FillColor         = espColor
                h.OutlineColor      = Color3.fromRGB(255, 255, 255)
                h.FillTransparency  = 0.5
                h.Adornee = char; h.Parent = char
                highlights[target] = h
            end
        else
            removeHighlight(target)
        end

        local anyESP = espTracers or espBoxes or espNames or espHealth or espDistance
        if not anyESP or not char or not tRoot or not alive or sameT then
            local d = playerDrawings[target]
            if d then for _, obj in pairs(d) do obj.Visible = false end end
            continue
        end

        local d       = getDrawings(target)
        local headPos = tRoot.Position + Vector3.new(0, 3.2, 0)
        local feetPos = tRoot.Position - Vector3.new(0, 3.2, 0)
        local headSc, headVis = camera:WorldToViewportPoint(headPos)
        local feetSc           = camera:WorldToViewportPoint(feetPos)
        local rootSc, rootVis  = camera:WorldToViewportPoint(tRoot.Position)
        local vis = headVis or rootVis

        if espTracers and vis then
            local vp = camera.ViewportSize
            d.tracer.From = Vector2.new(vp.X / 2, vp.Y)
            d.tracer.To   = Vector2.new(feetSc.X, feetSc.Y)
            d.tracer.Color   = espColor; d.tracer.Visible = true
        else d.tracer.Visible = false end

        if espBoxes and vis then
            local h2  = math.abs(headSc.Y - feetSc.Y)
            local w   = h2 * 0.42
            local cx  = rootSc.X
            local top, bot = headSc.Y, feetSc.Y
            local lft, rgt = cx - w, cx + w
            d.boxT.From = Vector2.new(lft,top); d.boxT.To = Vector2.new(rgt,top); d.boxT.Color = espColor; d.boxT.Visible = true
            d.boxB.From = Vector2.new(lft,bot); d.boxB.To = Vector2.new(rgt,bot); d.boxB.Color = espColor; d.boxB.Visible = true
            d.boxL.From = Vector2.new(lft,top); d.boxL.To = Vector2.new(lft,bot); d.boxL.Color = espColor; d.boxL.Visible = true
            d.boxR.From = Vector2.new(rgt,top); d.boxR.To = Vector2.new(rgt,bot); d.boxR.Color = espColor; d.boxR.Visible = true
        else d.boxT.Visible = false; d.boxB.Visible = false; d.boxL.Visible = false; d.boxR.Visible = false end

        if espNames and vis then
            local offset = espHealth and -40 or -18
            d.name.Position = Vector2.new(headSc.X, headSc.Y + offset)
            d.name.Text = target.DisplayName; d.name.Visible = true
        else d.name.Visible = false end

        if espHealth and vis then
            d.health.Position = Vector2.new(headSc.X, headSc.Y - 18)
            d.health.Text = math.floor(tHum.Health) .. " / " .. math.floor(tHum.MaxHealth) .. " HP"
            d.health.Visible = true
        else d.health.Visible = false end

        if espDistance and vis and rootPart then
            local dist = math.floor((rootPart.Position - tRoot.Position).Magnitude)
            d.distance.Position = Vector2.new(feetSc.X, feetSc.Y + 4)
            d.distance.Text = dist .. " studs"; d.distance.Visible = true
        else d.distance.Visible = false end
    end
end)

Players.PlayerRemoving:Connect(function(target)
    removeHighlight(target)
    removeDrawings(target)
end)

-- ═════════════════════════════════════════════════════════════════════════════
-- TABS
-- ═════════════════════════════════════════════════════════════════════════════
local MainTab    = Window:Tab({ Title = "Main",    Icon = "zap",          ShowTabTitle = true, Border = true })
local VisualsTab = Window:Tab({ Title = "Visuals", Icon = "eye",          ShowTabTitle = true, Border = true })
local AimbotTab  = Window:Tab({ Title = "Aimbot",  Icon = "crosshair",    ShowTabTitle = true, Border = true })
local ExtrasTab  = Window:Tab({ Title = "Extras",  Icon = "wrench",       ShowTabTitle = true, Border = true })
local MiscTab    = Window:Tab({ Title = "Misc",    Icon = "blocks",       ShowTabTitle = true, Border = true })
local InfoTab    = Window:Tab({ Title = "Info",    Icon = "info",         ShowTabTitle = true, Border = true })

Window:SelectTab(MainTab)

-- ═════════════════════════════════════════════════════════════════════════════
-- MAIN TAB
-- ═════════════════════════════════════════════════════════════════════════════
local mainSection = MainTab:Section({
    Title     = "Character Movement",
    Desc      = "Speed, flight, and movement features.",
    Icon      = "person-standing",
    Opened    = true,
    Box       = true,
    BoxBorder = true,
})

mainSection:Slider({
    Title     = "Walk Speed",
    Desc      = "Adjust your walk speed.",
    Value     = { Min = 16, Max = 500, Default = 16 },
    Step      = 1,
    Suffix    = " WS",
    IsTextbox = true,
    IsTooltip = true,
    Callback  = function(v)
        if humanoid then humanoid.WalkSpeed = v end
    end,
})

mainSection:Slider({
    Title     = "Jump Power",
    Desc      = "Adjust your jump power.",
    Value     = { Min = 50, Max = 500, Default = 50 },
    Step      = 1,
    Suffix    = " JP",
    IsTextbox = true,
    IsTooltip = true,
    Callback  = function(v)
        if humanoid then humanoid.JumpPower = v end
    end,
})

mainSection:Toggle({
    Title = "Fly",
    Desc  = "Enables flight. Use W/A/S/D, Space (up), Left Shift (down).",
    Icon  = "bird",
    Type  = "Toggle",
    Value = false,
    Callback = function(state)
        flyEnabled = state
        if state then startFly() end
        notify("Fly", state and "Enabled." or "Disabled.", "bird")
    end,
})

mainSection:Slider({
    Title     = "Fly Speed",
    Desc      = "Adjust fly speed.",
    Value     = { Min = 5, Max = 500, Default = 50 },
    Step      = 5,
    Suffix    = " spd",
    IsTextbox = true,
    IsTooltip = true,
    Callback  = function(v)
        flySpeed = v
    end,
})

mainSection:Toggle({
    Title = "Noclip",
    Desc  = "Clip through walls.",
    Icon  = "layers",
    Type  = "Toggle",
    Value = false,
    Callback = function(state)
        noclipEnabled = state
        if state then enableNoclip() else disableNoclip() end
        notify("Noclip", state and "Enabled." or "Disabled.", "layers")
    end,
})

mainSection:Toggle({
    Title = "Airwalk",
    Desc  = "Creates an invisible platform under your feet.",
    Icon  = "footprints",
    Type  = "Toggle",
    Value = false,
    Callback = function(state)
        airwalkEnabled = state
        if state then enableAirwalk() else disableAirwalk() end
        notify("Airwalk", state and "Enabled." or "Disabled.", "footprints")
    end,
})

mainSection:Toggle({
    Title = "Infinite Jump",
    Desc  = "Jump infinitely in the air.",
    Icon  = "arrow-up",
    Type  = "Toggle",
    Value = false,
    Callback = function(state)
        infJumpEnabled = state
        notify("Infinite Jump", state and "Enabled." or "Disabled.", "arrow-up")
    end,
})

mainSection:Paragraph({
    Title = "Fly Controls",
    Desc  = "W / A / S / D — Move   |   Space — Up   |   Left Shift — Down",
})

-- ═════════════════════════════════════════════════════════════════════════════
-- VISUALS TAB
-- ═════════════════════════════════════════════════════════════════════════════
local espSection = VisualsTab:Section({
    Title     = "ESP",
    Desc      = "Player highlighting, tracers, boxes and more.",
    Icon      = "eye",
    Opened    = true,
    Box       = true,
    BoxBorder = true,
})

espSection:ColorPicker({
    Title   = "ESP Color",
    Desc    = "Change the color of all ESP elements.",
    Default = Color3.fromRGB(255, 60, 60),
    Callback = function(color)
        espColor = color
        updateAllDrawingColors()
    end,
})

espSection:Toggle({
    Title = "Highlight Players",
    Desc  = "Highlight all enemy players.",
    Icon  = "users",
    Type  = "Checkbox",
    Value = false,
    Callback = function(state)
        espHighlight = state
        if not state then
            for _, p in ipairs(Players:GetPlayers()) do removeHighlight(p) end
        end
        notify("Highlight", state and "Enabled." or "Disabled.", "users")
    end,
})

espSection:Toggle({
    Title = "Tracers",
    Desc  = "Draw lines from screen bottom to each player.",
    Icon  = "move-diagonal",
    Type  = "Checkbox",
    Value = false,
    Callback = function(state) espTracers = state; notify("Tracers", state and "Enabled." or "Disabled.", "move-diagonal") end,
})

espSection:Toggle({
    Title = "Boxes",
    Desc  = "Draw 2D boxes around players.",
    Icon  = "square",
    Type  = "Checkbox",
    Value = false,
    Callback = function(state) espBoxes = state; notify("Boxes", state and "Enabled." or "Disabled.", "square") end,
})

espSection:Toggle({
    Title = "Names",
    Desc  = "Show player display names.",
    Icon  = "tag",
    Type  = "Checkbox",
    Value = false,
    Callback = function(state) espNames = state; notify("Names", state and "Enabled." or "Disabled.", "tag") end,
})

espSection:Toggle({
    Title = "Health",
    Desc  = "Show player health above their head.",
    Icon  = "heart-pulse",
    Type  = "Checkbox",
    Value = false,
    Callback = function(state) espHealth = state; notify("Health ESP", state and "Enabled." or "Disabled.", "heart-pulse") end,
})

espSection:Toggle({
    Title = "Distance",
    Desc  = "Show distance to each player in studs.",
    Icon  = "ruler",
    Type  = "Checkbox",
    Value = false,
    Callback = function(state) espDistance = state; notify("Distance", state and "Enabled." or "Disabled.", "ruler") end,
})

espSection:Toggle({
    Title = "Team Check",
    Desc  = "Skip teammates in ESP.",
    Icon  = "shield",
    Type  = "Checkbox",
    Value = false,
    Callback = function(state) teamCheck = state; notify("Team Check", state and "Enabled." or "Disabled.", "shield") end,
})

VisualsTab:Divider({})

local lightSection = VisualsTab:Section({
    Title     = "Lighting",
    Desc      = "Fullbright and lighting controls.",
    Icon      = "sun",
    Opened    = true,
    Box       = true,
    BoxBorder = true,
})

lightSection:Toggle({
    Title = "Fullbright",
    Desc  = "Removes all shadows and darkness.",
    Icon  = "sun",
    Type  = "Toggle",
    Value = false,
    Callback = function(state)
        fullbright = state
        if state then enableFullbright() else disableFullbright() end
        notify("Fullbright", state and "Enabled." or "Disabled.", "sun")
    end,
})

-- ═════════════════════════════════════════════════════════════════════════════
-- AIMBOT TAB
-- ═════════════════════════════════════════════════════════════════════════════
local aimSection = AimbotTab:Section({
    Title     = "Aimbot",
    Desc      = "Lock onto players automatically.",
    Icon      = "crosshair",
    Opened    = true,
    Box       = true,
    BoxBorder = true,
})

aimSection:Toggle({
    Title = "Aimbot",
    Desc  = "Automatically aims at the closest player in FOV.",
    Icon  = "crosshair",
    Type  = "Toggle",
    Value = false,
    Callback = function(state)
        aimbotEnabled = state
        notify("Aimbot", state and "Enabled." or "Disabled.", "crosshair")
    end,
})

aimSection:Slider({
    Title     = "Smoothness",
    Desc      = "Higher = slower camera movement. 1 = instant snap.",
    Value     = { Min = 1, Max = 20, Default = 1 },
    Step      = 1,
    Suffix    = " lvl",
    IsTextbox = true,
    IsTooltip = true,
    Callback  = function(v) aimSmoothness = v end,
})

aimSection:Toggle({
    Title = "Wall Check",
    Desc  = "Only target players visible through walls.",
    Icon  = "wall",
    Type  = "Toggle",
    Value = false,
    Callback = function(state)
        aimWallCheck = state
        notify("Wall Check", state and "Enabled." or "Disabled.", "wall")
    end,
})

aimSection:Toggle({
    Title = "Team Check",
    Desc  = "Skip teammates when aiming.",
    Icon  = "shield",
    Type  = "Toggle",
    Value = false,
    Callback = function(state)
        aimTeamCheck = state
        notify("Team Check", state and "Enabled." or "Disabled.", "shield")
    end,
})

aimSection:Slider({
    Title     = "FOV Radius",
    Desc      = "Size of the aimbot detection circle in pixels.",
    Value     = { Min = 10, Max = 800, Default = 100 },
    Step      = 10,
    Suffix    = " px",
    IsTextbox = true,
    IsTooltip = true,
    Callback  = function(v) aimFovRadius = v end,
})

aimSection:Toggle({
    Title = "Show FOV",
    Desc  = "Draw the FOV circle on screen.",
    Icon  = "circle",
    Type  = "Toggle",
    Value = false,
    Callback = function(state)
        aimShowFov = state
        notify("Show FOV", state and "Enabled." or "Disabled.", "circle")
    end,
})

aimSection:Toggle({
    Title = "RGB FOV",
    Desc  = "Make the FOV circle cycle through colors.",
    Icon  = "palette",
    Type  = "Toggle",
    Value = false,
    Callback = function(state)
        aimRgbFov = state
        notify("RGB FOV", state and "Enabled." or "Disabled.", "palette")
    end,
})

aimSection:Toggle({
    Title = "Toggle by RMB",
    Desc  = "Only aim while holding right mouse button.",
    Icon  = "mouse-pointer",
    Type  = "Toggle",
    Value = false,
    Callback = function(state)
        aimToggleRmb = state
        notify("RMB Toggle", state and "Enabled." or "Disabled.", "mouse-pointer")
    end,
})

-- ═════════════════════════════════════════════════════════════════════════════
-- EXTRAS TAB
-- ═════════════════════════════════════════════════════════════════════════════
local extrasSection = ExtrasTab:Section({
    Title     = "Tools",
    Desc      = "Utility scripts and world controls.",
    Icon      = "wrench",
    Opened    = true,
    Box       = true,
    BoxBorder = true,
})

extrasSection:Button({
    Title    = "TP List",
    Desc     = "Loads a teleport list script.",
    Icon     = "map-pin",
    Callback = function()
        loadstring(game:HttpGet("https://pastefy.app/ypGIY08v/raw"))()
        notify("TP List", "Loaded successfully.", "map-pin")
    end,
})

extrasSection:Button({
    Title    = "Give TP Tool",
    Desc     = "Gives you a teleport tool.",
    Icon     = "wand",
    Callback = function()
        loadstring(game:HttpGet("https://gist.githubusercontent.com/manueljrtalidano14-wq/0e871d4d90f371635e441cc613178ba9/raw/"))()
        notify("TP Tool", "Tool given successfully.", "wand")
    end,
})

extrasSection:Button({
    Title    = "Invisible GUI",
    Desc     = "Opens the invisible body GUI.",
    Icon     = "eye-off",
    Callback = function()
        loadstring(game:HttpGet("https://gist.githubusercontent.com/maks1165/b49e0fd87fc998e138433aaa1e854111/raw/760f4c82d8e3425f48512f14e8a52bfd359ac1d3/Invisible"))()
        notify("Invisible GUI", "Loaded successfully.", "eye-off")
    end,
})

ExtrasTab:Divider({})

local worldSection = ExtrasTab:Section({
    Title     = "World",
    Desc      = "Control gravity and time of day.",
    Icon      = "globe",
    Opened    = true,
    Box       = true,
    BoxBorder = true,
})

worldSection:Slider({
    Title     = "Gravity",
    Desc      = "Change the world gravity.",
    Value     = { Min = 5, Max = 300, Default = 196 },
    Step      = 5,
    Suffix    = " G",
    IsTextbox = true,
    IsTooltip = true,
    Callback  = function(v) workspace.Gravity = v end,
})

worldSection:Button({
    Title    = "Reset Gravity",
    Desc     = "Resets gravity to default.",
    Icon     = "rotate-ccw",
    Callback = function()
        workspace.Gravity = origGravity
        notify("Gravity", "Reset to default.", "rotate-ccw")
    end,
})

worldSection:Slider({
    Title     = "Time of Day",
    Desc      = "Change the lighting clock time.",
    Value     = { Min = 0, Max = 24, Default = math.floor(Lighting.ClockTime) },
    Step      = 1,
    Suffix    = ":00",
    IsTextbox = true,
    IsTooltip = true,
    Callback  = function(v) Lighting.ClockTime = v end,
})

ExtrasTab:Divider({})

local utilSection = ExtrasTab:Section({
    Title     = "Utilities",
    Desc      = "Anti AFK and other utilities.",
    Icon      = "shield-check",
    Opened    = true,
    Box       = true,
    BoxBorder = true,
})

utilSection:Toggle({
    Title = "Anti AFK",
    Desc  = "Prevents you from being kicked for inactivity.",
    Icon  = "clock",
    Type  = "Toggle",
    Value = false,
    Callback = function(state)
        antiAfkEnabled = state
        if state then enableAntiAfk() else disableAntiAfk() end
        notify("Anti AFK", state and "Enabled." or "Disabled.", "clock")
    end,
})

-- ═════════════════════════════════════════════════════════════════════════════
-- MISC TAB
-- ═════════════════════════════════════════════════════════════════════════════
local miscSection = MiscTab:Section({
    Title     = "Miscellaneous",
    Desc      = "Server, session and UI controls.",
    Icon      = "blocks",
    Opened    = true,
    Box       = true,
    BoxBorder = true,
})

miscSection:Button({
    Title    = "Rejoin",
    Desc     = "Rejoins the current game.",
    Icon     = "refresh-cw",
    Callback = function()
        TeleportService:Teleport(game.PlaceId, player)
    end,
})

miscSection:Button({
    Title    = "Server Hop",
    Desc     = "Hops to a different server.",
    Icon     = "shuffle",
    Callback = function()
        local ok, res = pcall(function()
            return game:HttpGet(
                "https://games.roblox.com/v1/games/"
                .. game.PlaceId
                .. "/servers/Public?sortOrder=Asc&limit=100"
            )
        end)
        if ok then
            local data = HttpService:JSONDecode(res)
            for _, s in ipairs(data.data) do
                if s.id ~= game.JobId and s.playing < s.maxPlayers then
                    TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id, player)
                    return
                end
            end
            notify("Server Hop", "No open servers found.", "alert-triangle")
        else
            notify("Server Hop", "Failed to fetch servers.", "alert-triangle")
        end
    end,
})

miscSection:Button({
    Title    = "Destroy UI",
    Desc     = "Removes the GUI completely.",
    Icon     = "trash",
    Callback = function()
        flyEnabled    = false
        noclipEnabled = false
        airwalkEnabled = false
        aimbotEnabled = false
        aimShowFov    = false
        fovCircle:Remove()
        disableNoclip()
        disableAirwalk()
        disableFullbright()
        disableAntiAfk()
        workspace.Gravity = origGravity
        for _, p in ipairs(Players:GetPlayers()) do
            removeHighlight(p)
            removeDrawings(p)
        end
        WindUI:Destroy()
        notify("UI", "Destroyed.", "trash")
    end,
})

-- ═════════════════════════════════════════════════════════════════════════════
-- INFO TAB
-- ═════════════════════════════════════════════════════════════════════════════
InfoTab:Paragraph({
    Title = "Hub Information",
    Desc  = "Creator: Em_Jay225\nHub: Ultimate Hub\nPort: WindUI Boreal\nFeatures: 32\nLast Updated: May 2026",
})

InfoTab:Divider({})

InfoTab:Paragraph({
    Title = "Keybinds",
    Desc  = "Show / Hide GUI: Right Alt",
})

-- ==================== NOTIFY ON LOAD ====================
WindUI:Notify({
    Title    = "✦ Ultimate Hub",
    Content  = "All features ready!",
    Icon     = "check",
    Duration = 5,
})
