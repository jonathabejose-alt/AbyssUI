
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/jonathabejose-alt/Wind-UI-Boreal/refs/heads/main/Neverlose%20boreal%20UI.lua"))()


        -- ==================== SERVICES ====================
        local UIS = game:GetService("UserInputService")
        local RunService = game:GetService("RunService")
        local Players = game:GetService("Players")
        local Lighting = game:GetService("Lighting")
        local TeleportService = game:GetService("TeleportService")
        local HttpService = game:GetService("HttpService")
        local TweenService = game:GetService("TweenService")
        local Camera = workspace.CurrentCamera
        local Player = Players.LocalPlayer

        -- ==================== SETTINGS ====================
        local Settings = {
            -- Aimbot
            AimbotEnabled = false,
            FOV = 150,
            HitPart = "Head",
            WallCheck = false,
            TeamCheck = false,
            ShowFOV = true,
            FOVColor = Color3.fromRGB(255, 255, 255),
            -- ESP
            Boxes = false,
            BoxColor = Color3.fromRGB(255, 255, 255),
            Names = false,
            NameColor = Color3.fromRGB(255, 255, 255),
            Distance = false,
            DistanceColor = Color3.fromRGB(200, 200, 200),
            Tracers = false,
            TracerColor = Color3.fromRGB(255, 255, 255),
            HealthBar = false,
            -- World
            Fullbright = false,
            NoFog = false,
            CustomTime = false,
            TimeValue = 14,
            AmbientColor = Color3.fromRGB(178, 178, 178),
            -- Movement
            SpeedEnabled = false,
            SpeedValue = 32,
            FlyEnabled = false,
            FlySpeed = 50,
            NoclipEnabled = false,
            InfJumpEnabled = false,
            JumpPower = false,
            JumpValue = 50,
            -- Misc
            AntiAFK = true,
            ClickTP = false,
        }

        -- Save original lighting
        local OriginalLighting = {
            Brightness = Lighting.Brightness,
            ClockTime = Lighting.ClockTime,
            FogEnd = Lighting.FogEnd,
            GlobalShadows = Lighting.GlobalShadows,
            Ambient = Lighting.Ambient,
        }

        -- ==================== NOTIFY FUNCTION ====================
        local function notify(title, desc, duration)
            Library:Notification({
                Title = title,
                Description = desc,
                Icon = "107759198829431",
                Duration = duration or 3
            })
        end

        -- ==================== AIMBOT CORREGIDO (SIN CLICK DERECHO) ====================
        local renderConnection = nil
        local FOVCircle = Drawing.new("Circle")
        FOVCircle.Thickness = 1
        FOVCircle.Filled = false
        FOVCircle.NumSides = 64

        local function IsEnemy(plr)
            if not Settings.TeamCheck then return true end
            if plr.Team ~= nil and Player.Team ~= nil then
                return plr.Team ~= Player.Team
            end
            return true
        end

        local function IsVisible(targetPart)
            if not Settings.WallCheck then return true end
            local params = RaycastParams.new()
            params.FilterDescendantsInstances = {Camera, Player.Character}
            params.FilterType = Enum.RaycastFilterType.Exclude
            local cast = workspace:Raycast(Camera.CFrame.Position, targetPart.Position - Camera.CFrame.Position, params)
            if cast and cast.Instance then return cast.Instance:IsDescendantOf(targetPart.Parent) end
            return true
        end

        local function GetCharacterTargetPart(char)
            if not char then return nil end
            local part = char:FindFirstChild(Settings.HitPart)
            if part and part:IsA("BasePart") then return part end
            return char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
        end

        local function UpdateTarget()
            local target, closestDist = nil, Settings.FOV
            local mousePos = UIS:GetMouseLocation()
            
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= Player and plr.Character and IsEnemy(plr) then
                    local targetPart = GetCharacterTargetPart(plr.Character)
                    local hum = plr.Character:FindFirstChildOfClass("Humanoid")
                    
                    if targetPart and hum and hum.Health > 0 then
                        local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                        if onScreen then
                            local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                            if dist < closestDist and IsVisible(targetPart) then
                                closestDist = dist
                                target = targetPart
                            end
                        end
                    end
                end
            end
            return target
        end

        -- Aimbot toggle (SOLO con tecla X)
        local function toggleAimbot()
            Settings.AimbotEnabled = not Settings.AimbotEnabled
            notify("Aimbot", Settings.AimbotEnabled and "Enabled ✓" or "Disabled ✗", 1)
        end

        -- Tecla X para toggle
        local aimbotKey = Enum.KeyCode.X
        UIS.InputBegan:Connect(function(input, gp)
            if gp then return end
            if input.KeyCode == aimbotKey then
                toggleAimbot()
            end
        end)

        -- Render loop del aimbot (auto-lock al más cercano)
        RunService.RenderStepped:Connect(function()
            Camera = workspace.CurrentCamera
            
            -- FOV Circle
            FOVCircle.Visible = Settings.AimbotEnabled and Settings.ShowFOV
            FOVCircle.Radius = Settings.FOV
            FOVCircle.Position = UIS:GetMouseLocation()
            FOVCircle.Color = Settings.FOVColor
            
            -- Aimbot auto-lock
            if Settings.AimbotEnabled then
                local target = UpdateTarget()
                if target and target.Parent then
                    Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position)
                end
            end
        end)

        -- ==================== FLY ====================
        local flyConnection = nil

        local function updateFly()
            local char = Player.Character
            local rootPart = char and char:FindFirstChild("HumanoidRootPart")
            local humanoid = char and char:FindFirstChildOfClass("Humanoid")

            if not char or not rootPart or not humanoid then return end

            if Settings.FlyEnabled then
                if not flyConnection then
                    humanoid.PlatformStand = true

                    local bv = Instance.new("BodyVelocity")
                    bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
                    bv.Velocity = Vector3.zero
                    bv.Parent = rootPart

                    local bg = Instance.new("BodyGyro")
                    bg.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
                    bg.Parent = rootPart

                    flyConnection = RunService.RenderStepped:Connect(function()
                        if not Settings.FlyEnabled or not rootPart or not rootPart.Parent then
                            bv:Destroy()
                            bg:Destroy()
                            if humanoid then humanoid.PlatformStand = false end
                            flyConnection:Disconnect()
                            flyConnection = nil
                            return
                        end

                        local cf = Camera.CFrame
                        local dir = Vector3.zero

                        if UIS:IsKeyDown(Enum.KeyCode.W) then dir = dir + cf.LookVector end
                        if UIS:IsKeyDown(Enum.KeyCode.S) then dir = dir - cf.LookVector end
                        if UIS:IsKeyDown(Enum.KeyCode.A) then dir = dir - cf.RightVector end
                        if UIS:IsKeyDown(Enum.KeyCode.D) then dir = dir + cf.RightVector end
                        if UIS:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0, 1, 0) end
                        if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then dir = dir - Vector3.new(0, 1, 0) end

                        local velocity = dir.Magnitude > 0 and dir.Unit * Settings.FlySpeed or Vector3.zero
                        bv.Velocity = velocity
                        bg.CFrame = cf
                    end)
                end
            elseif flyConnection then
                flyConnection:Disconnect()
                flyConnection = nil
                if humanoid then humanoid.PlatformStand = false end
            end
        end

        -- ==================== NOCLIP ====================
        local noclipConnection = nil

        local function updateNoclip()
            local char = Player.Character
            if not char then return end

            if Settings.NoclipEnabled then
                if not noclipConnection then
                    noclipConnection = RunService.Stepped:Connect(function()
                        if not Settings.NoclipEnabled or not Player.Character then return end
                        for _, part in ipairs(Player.Character:GetDescendants()) do
                            if part:IsA("BasePart") then
                                part.CanCollide = false
                            end
                        end
                    end)
                end
            elseif noclipConnection then
                noclipConnection:Disconnect()
                noclipConnection = nil
                if char then
                    for _, part in ipairs(char:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = true
                        end
                    end
                end
            end
        end

        -- ==================== INFINITE JUMP ====================
        UIS.JumpRequest:Connect(function()
            if Settings.InfJumpEnabled then
                local hum = Player.Character and Player.Character:FindFirstChildOfClass("Humanoid")
                if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
            end
        end)

        -- ==================== CLICK TP ====================
        UIS.InputBegan:Connect(function(input, gp)
            if Settings.ClickTP and input.UserInputType == Enum.UserInputType.MouseButton1 and UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
                pcall(function()
                    local mouse = Player:GetMouse()
                    if mouse.Target then
                        local root = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
                        if root then root.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0, 3, 0)) end
                    end
                end)
            end
        end)

        -- ==================== ANTI AFK ====================
        Player.Idled:Connect(function()
            if Settings.AntiAFK then
                pcall(function()
                    local VU = game:GetService("VirtualUser")
                    VU:Button2Down(Vector2.new(), Camera.CFrame)
                    task.wait(1)
                    VU:Button2Up(Vector2.new(), Camera.CFrame)
                end)
            end
        end)

        -- ==================== ESP ====================
        local ESPCache = {}

        local function GetESP(plr)
            if not ESPCache[plr] then
                ESPCache[plr] = {
                    Box = Drawing.new("Square"),
                    BoxOutline = Drawing.new("Square"),
                    Name = Drawing.new("Text"),
                    Distance = Drawing.new("Text"),
                    Tracer = Drawing.new("Line"),
                    HealthBarBG = Drawing.new("Square"),
                    HealthBar = Drawing.new("Square"),
                }
                local esp = ESPCache[plr]
                esp.Box.Thickness = 1; esp.Box.Filled = false
                esp.BoxOutline.Thickness = 2; esp.BoxOutline.Filled = false; esp.BoxOutline.Color = Color3.new(0,0,0)
                esp.Name.Center = true; esp.Name.Size = 14; esp.Name.Outline = true
                esp.Distance.Center = true; esp.Distance.Size = 12; esp.Distance.Outline = true
                esp.Tracer.Thickness = 1
                esp.HealthBarBG.Filled = true; esp.HealthBarBG.Color = Color3.new(0,0,0)
                esp.HealthBar.Filled = true
            end
            return ESPCache[plr]
        end

        Players.PlayerRemoving:Connect(function(plr)
            if ESPCache[plr] then
                for _, v in pairs(ESPCache[plr]) do pcall(function() v:Remove() end) end
                ESPCache[plr] = nil
            end
        end)

        -- ==================== CREATE WINDOW ====================
        local Window = Library:Window({
            Name = "Abyss UI",
            SubName = "Universal | by tze",
            Logo = "120959262762131"
        })

        local KeybindList = Library:KeybindList("Keybinds")

        Library:Watermark({"Abyss UI", "|", "by tze"})

        Library:Thread(function()
            while task.wait(1) do
                Library:Watermark({"Abyss UI", "|", "FPS: " .. math.floor(1 / RunService.Heartbeat:Wait())})
            end
        end)

        Library:CreateSettingsPage(Window, KeybindList)

        -- ==================== FLOATING BUTTON ====================
        local FloatingButton = Instance.new("TextButton")
        FloatingButton.Size = UDim2.new(0, 55, 0, 55)
        FloatingButton.Position = UDim2.new(0.85, 0, 0.85, 0)
        FloatingButton.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
        FloatingButton.Text = "A"
        FloatingButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        FloatingButton.TextSize = 28
        FloatingButton.Font = Enum.Font.GothamBold
        FloatingButton.Parent = gethui()
        FloatingButton.ZIndex = 999
        Instance.new("UICorner", FloatingButton).CornerRadius = UDim.new(1, 0)

        local ButtonGlow = Instance.new("Frame")
        ButtonGlow.Size = UDim2.new(1.2, 0, 1.2, 0)
        ButtonGlow.Position = UDim2.new(0.5, -33, 0.5, -33)
        ButtonGlow.BackgroundColor3 = Color3.fromRGB(100, 0, 200)
        ButtonGlow.BackgroundTransparency = 0.6
        ButtonGlow.BorderSizePixel = 0
        ButtonGlow.ZIndex = 998
        ButtonGlow.Parent = FloatingButton
        Instance.new("UICorner", ButtonGlow).CornerRadius = UDim.new(1, 0)

        -- Pulse animation
        task.spawn(function()
            while FloatingButton.Parent do
                TweenService:Create(ButtonGlow, TweenInfo.new(1, Enum.EasingStyle.Sine), {
                    BackgroundTransparency = 0.3,
                    Size = UDim2.new(1.4, 0, 1.4, 0),
                    Position = UDim2.new(0.5, -38, 0.5, -38)
                }):Play()
                task.wait(0.6)
                TweenService:Create(ButtonGlow, TweenInfo.new(1, Enum.EasingStyle.Sine), {
                    BackgroundTransparency = 0.6,
                    Size = UDim2.new(1.2, 0, 1.2, 0),
                    Position = UDim2.new(0.5, -33, 0.5, -33)
                }):Play()
                task.wait(0.6)
            end
        end)

        -- Make button draggable
        local dragging = false
        local dragStart
        local startPos
        
        FloatingButton.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = FloatingButton.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)
        
        UIS.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local delta = input.Position - dragStart
                FloatingButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
        
        -- Toggle menu on click
        local menuOpen = false
        FloatingButton.MouseButton1Click:Connect(function()
            menuOpen = not menuOpen
            Window.Window.Instance.Visible = menuOpen
            FloatingButton.BackgroundColor3 = menuOpen and Color3.fromRGB(80, 80, 100) or Color3.fromRGB(20, 20, 30)
        end)

        -- ==================== PAGE 1: COMBAT ====================
        Window:Category("Combat")

        local CombatPage = Window:Page({
            Name = "Combat",
            Icon = "107759198829431",
            Columns = 2
        })

        -- Aimbot Section
        local AimSection = CombatPage:Section({
            Name = "Aimbot",
            Description = "Aimbot configuration",
            Icon = "107759198829431",
            Side = 1,
            EnableToggle = true
        })

        AimSection:Toggle({
            Name = "Enable Aimbot",
            Flag = "AimbotEnabled",
            Default = false,
            Callback = function(v) 
                if v ~= Settings.AimbotEnabled then
                    toggleAimbot()
                end
            end
        })

        AimSection:Slider({
            Name = "FOV Size",
            Flag = "FOVSize",
            Min = 30,
            Max = 500,
            Default = 150,
            Suffix = "px",
            Callback = function(v) Settings.FOV = v end
        })

        AimSection:Dropdown({
            Name = "Hit Part",
            Flag = "AimbotPart",
            Items = {"Head", "HumanoidRootPart"},
            Default = "Head",
            Callback = function(v) Settings.HitPart = v end
        })

        AimSection:Toggle({
            Name = "Wall Check",
            Flag = "WallCheck",
            Default = false,
            Callback = function(v) Settings.WallCheck = v end
        })

        AimSection:Toggle({
            Name = "Team Check",
            Flag = "TeamCheck",
            Default = false,
            Callback = function(v) Settings.TeamCheck = v end
        })

        AimSection:Toggle({
            Name = "Show FOV",
            Flag = "ShowFOV",
            Default = true,
            Callback = function(v) Settings.ShowFOV = v end
        })

        local ColorLabel = AimSection:Label("FOV Color")
        ColorLabel:Colorpicker({
            Flag = "FOVColor",
            Default = Color3.fromRGB(255, 255, 255),
            Alpha = 1,
            Callback = function(Color) Settings.FOVColor = Color end
        })

        AimSection:Label("Aimbot Key: X (press to toggle)")

        -- ESP Section
        local ESPSection = CombatPage:Section({
            Name = "ESP",
            Description = "Visual configuration",
            Icon = "107759198829431",
            Side = 2,
            EnableToggle = true
        })

        ESPSection:Toggle({
            Name = "Box ESP",
            Flag = "BoxESP",
            Default = false,
            Callback = function(v) Settings.Boxes = v end
        })

        ESPSection:Toggle({
            Name = "Name ESP",
            Flag = "NameESP",
            Default = false,
            Callback = function(v) Settings.Names = v end
        })

        ESPSection:Toggle({
            Name = "Health Bar",
            Flag = "HealthBar",
            Default = false,
            Callback = function(v) Settings.HealthBar = v end
        })

        ESPSection:Toggle({
            Name = "Distance",
            Flag = "Distance",
            Default = false,
            Callback = function(v) Settings.Distance = v end
        })

        ESPSection:Toggle({
            Name = "Tracers",
            Flag = "Tracers",
            Default = false,
            Callback = function(v) Settings.Tracers = v end
        })

        local ESPColorLabel = ESPSection:Label("ESP Color")
        ESPColorLabel:Colorpicker({
            Flag = "ESPColor",
            Default = Color3.fromRGB(255, 0, 0),
            Alpha = 1,
            Callback = function(Color) 
                Settings.BoxColor = Color
                Settings.NameColor = Color
                Settings.TracerColor = Color
            end
        })

        -- ==================== PAGE 2: MOVEMENT ====================
        Window:Category("Movement")

        local MovePage = Window:Page({
            Name = "Movement",
            Icon = "107759198829431",
            Columns = 2
        })

        local MoveSection = MovePage:Section({
            Name = "Movement",
            Icon = "107759198829431",
            Side = 1
        })

        MoveSection:Toggle({
            Name = "Speed Hack",
            Flag = "SpeedHack",
            Default = false,
            Callback = function(v) Settings.SpeedEnabled = v end
        })

        MoveSection:Slider({
            Name = "Walk Speed",
            Flag = "WalkSpeed",
            Min = 16,
            Max = 200,
            Default = 32,
            Suffix = " spd",
            Callback = function(v)
                Settings.SpeedValue = v
                local hum = Player.Character and Player.Character:FindFirstChildOfClass("Humanoid")
                if hum and Settings.SpeedEnabled then hum.WalkSpeed = v end
            end
        })

        MoveSection:Toggle({
            Name = "Fly",
            Flag = "Fly",
            Default = false,
            Callback = function(v) Settings.FlyEnabled = v end
        })

        MoveSection:Slider({
            Name = "Fly Speed",
            Flag = "FlySpeed",
            Min = 10,
            Max = 200,
            Default = 50,
            Suffix = " spd",
            Callback = function(v) Settings.FlySpeed = v end
        })

        MoveSection:Toggle({
            Name = "Noclip",
            Flag = "Noclip",
            Default = false,
            Callback = function(v) Settings.NoclipEnabled = v end
        })

        MoveSection:Toggle({
            Name = "Infinite Jump",
            Flag = "InfJump",
            Default = false,
            Callback = function(v) Settings.InfJumpEnabled = v end
        })

        MoveSection:Toggle({
            Name = "Jump Power",
            Flag = "JumpPower",
            Default = false,
            Callback = function(v) Settings.JumpPower = v end
        })

        MoveSection:Slider({
            Name = "Jump Value",
            Flag = "JumpValue",
            Min = 50,
            Max = 300,
            Default = 50,
            Suffix = " pw",
            Callback = function(v) Settings.JumpValue = v end
        })

        -- ==================== PAGE 3: WORLD ====================
        Window:Category("World")

        local WorldPage = Window:Page({
            Name = "World",
            Icon = "107759198829431",
            Columns = 2
        })

        local WorldSection = WorldPage:Section({
            Name = "World",
            Icon = "107759198829431",
            Side = 1
        })

        WorldSection:Toggle({
            Name = "Fullbright",
            Flag = "Fullbright",
            Default = false,
            Callback = function(v) Settings.Fullbright = v end
        })

        WorldSection:Toggle({
            Name = "No Fog",
            Flag = "NoFog",
            Default = false,
            Callback = function(v) Settings.NoFog = v end
        })

        WorldSection:Toggle({
            Name = "Custom Time",
            Flag = "CustomTime",
            Default = false,
            Callback = function(v) Settings.CustomTime = v end
        })

        WorldSection:Slider({
            Name = "Time of Day",
            Flag = "TimeOfDay",
            Min = 0,
            Max = 24,
            Default = 14,
            Suffix = ":00",
            Callback = function(v) Settings.TimeValue = v end
        })

        local AmbientLabel = WorldSection:Label("Ambient Color")
        AmbientLabel:Colorpicker({
            Flag = "AmbientColor",
            Default = Color3.fromRGB(178, 178, 178),
            Alpha = 1,
            Callback = function(Color) Settings.AmbientColor = Color end
        })

        -- ==================== PAGE 4: MISC ====================
        Window:Category("Misc")

        local MiscPage = Window:Page({
            Name = "Misc",
            Icon = "107759198829431",
            Columns = 2
        })

        local MiscSection = MiscPage:Section({
            Name = "Utility",
            Icon = "107759198829431",
            Side = 1
        })

        MiscSection:Toggle({
            Name = "Anti-AFK",
            Flag = "AntiAFK",
            Default = true,
            Callback = function(v) Settings.AntiAFK = v end
        })

        MiscSection:Toggle({
            Name = "Click TP (Ctrl+Click)",
            Flag = "ClickTP",
            Default = false,
            Callback = function(v) Settings.ClickTP = v end
        })

        MiscSection:Button({
            Name = "Rejoin",
            Callback = function()
                TeleportService:Teleport(game.PlaceId, Player)
            end
        })

        MiscSection:Button({
            Name = "Server Hop",
            Callback = function()
                pcall(function()
                    local data = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
                    for _, s in pairs(data.data) do
                        if s.id ~= game.JobId and s.playing < s.maxPlayers then
                            TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id, Player)
                            break
                        end
                    end
                end)
            end
        })

        MiscSection:Button({
            Name = "Reset Character",
            Callback = function()
                local hum = Player.Character and Player.Character:FindFirstChildOfClass("Humanoid")
                if hum then hum.Health = 0 end
            end
        })

        MiscSection:Button({
            Name = "Copy Game ID",
            Callback = function()
                setclipboard(tostring(game.PlaceId))
                notify("Copied", "Game ID copied to clipboard", 3)
            end
        })

        -- ==================== RENDER LOOP ====================
        RunService.RenderStepped:Connect(function()
            Camera = workspace.CurrentCamera
            local VP = Camera.ViewportSize

            -- Lighting
            if Settings.Fullbright then
                Lighting.Brightness = 2
                Lighting.ClockTime = 14
                Lighting.GlobalShadows = false
                Lighting.Ambient = Settings.AmbientColor
            else
                Lighting.Brightness = OriginalLighting.Brightness
                Lighting.GlobalShadows = OriginalLighting.GlobalShadows
                Lighting.Ambient = OriginalLighting.Ambient
                if not Settings.CustomTime then
                    Lighting.ClockTime = OriginalLighting.ClockTime
                end
            end

            if Settings.NoFog then
                Lighting.FogEnd = 999999
            else
                Lighting.FogEnd = OriginalLighting.FogEnd
            end

            if Settings.CustomTime then
                Lighting.ClockTime = Settings.TimeValue
            end

            -- ESP Render
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= Player then
                    local esp = GetESP(p)
                    local char = p.Character
                    if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Head") then
                        local hum = char:FindFirstChildOfClass("Humanoid")
                        if hum and hum.Health > 0 then
                            local hrp = char.HumanoidRootPart
                            local head = char.Head
                            local pos, vis = Camera:WorldToViewportPoint(hrp.Position)

                            if vis then
                                local headPos = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 1.5, 0))
                                local feetPos = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))
                                local height = math.abs(headPos.Y - feetPos.Y)
                                local width = height * 0.6
                                local topLeft = Vector2.new(pos.X - width / 2, headPos.Y)

                                -- Box
                                if Settings.Boxes then
                                    esp.BoxOutline.Position = topLeft
                                    esp.BoxOutline.Size = Vector2.new(width, height)
                                    esp.Box.Position = topLeft
                                    esp.Box.Size = Vector2.new(width, height)
                                    esp.Box.Color = Settings.BoxColor
                                    esp.BoxOutline.Visible = true
                                    esp.Box.Visible = true
                                else
                                    esp.BoxOutline.Visible = false
                                    esp.Box.Visible = false
                                end

                                -- Name
                                if Settings.Names then
                                    esp.Name.Position = Vector2.new(pos.X, headPos.Y - 18)
                                    esp.Name.Text = p.DisplayName
                                    esp.Name.Color = Settings.NameColor
                                    esp.Name.Visible = true
                                else
                                    esp.Name.Visible = false
                                end

                                -- Distance
                                if Settings.Distance then
                                    local root = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
                                    if root then
                                        esp.Distance.Text = math.floor((root.Position - hrp.Position).Magnitude) .. "m"
                                        esp.Distance.Position = Vector2.new(pos.X, feetPos.Y + 4)
                                        esp.Distance.Color = Settings.DistanceColor
                                        esp.Distance.Visible = true
                                    else
                                        esp.Distance.Visible = false
                                    end
                                else
                                    esp.Distance.Visible = false
                                end

                                -- Tracer
                                if Settings.Tracers then
                                    esp.Tracer.From = Vector2.new(VP.X / 2, VP.Y)
                                    esp.Tracer.To = Vector2.new(pos.X, feetPos.Y)
                                    esp.Tracer.Color = Settings.TracerColor
                                    esp.Tracer.Visible = true
                                else
                                    esp.Tracer.Visible = false
                                end

                                -- Health Bar
                                if Settings.HealthBar then
                                    local barX = topLeft.X - 5
                                    local barY = headPos.Y
                                    local barH = height
                                    local hpPct = hum.Health / hum.MaxHealth

                                    esp.HealthBarBG.Position = Vector2.new(barX, barY)
                                    esp.HealthBarBG.Size = Vector2.new(2, barH)
                                    esp.HealthBar.Position = Vector2.new(barX, barY + barH * (1 - hpPct))
                                    esp.HealthBar.Size = Vector2.new(2, barH * hpPct)
                                    esp.HealthBar.Color = Color3.fromRGB(255 * (1 - hpPct), 255 * hpPct, 0)
                                    esp.HealthBarBG.Visible = true
                                    esp.HealthBar.Visible = true
                                else
                                    esp.HealthBarBG.Visible = false
                                    esp.HealthBar.Visible = false
                                end
                            else
                                esp.BoxOutline.Visible = false
                                esp.Box.Visible = false
                                esp.Name.Visible = false
                                esp.Distance.Visible = false
                                esp.Tracer.Visible = false
                                esp.HealthBarBG.Visible = false
                                esp.HealthBar.Visible = false
                            end
                        else
                            esp.BoxOutline.Visible = false
                            esp.Box.Visible = false
                            esp.Name.Visible = false
                            esp.Distance.Visible = false
                            esp.Tracer.Visible = false
                            esp.HealthBarBG.Visible = false
                            esp.HealthBar.Visible = false
                        end
                    else
                        esp.BoxOutline.Visible = false
                        esp.Box.Visible = false
                        esp.Name.Visible = false
                        esp.Distance.Visible = false
                        esp.Tracer.Visible = false
                        esp.HealthBarBG.Visible = false
                        esp.HealthBar.Visible = false
                    end
                end
            end
        end)

        -- ==================== UPDATE LOOP ====================
        task.spawn(function()
            while true do
                updateFly()
                updateNoclip()

                local hum = Player.Character and Player.Character:FindFirstChildOfClass("Humanoid")
                if hum and Settings.SpeedEnabled then
                    hum.WalkSpeed = Settings.SpeedValue
                end

                if Settings.JumpPower then
                    local hum2 = Player.Character and Player.Character:FindFirstChildOfClass("Humanoid")
                    if hum2 then
                        hum2.JumpPower = Settings.JumpValue
                    end
                end

                task.wait(0.5)
            end
        end)

        -- Reset on death
        Player.CharacterAdded:Connect(function()
            task.wait(0.5)
            Settings.FlyEnabled = false
            Settings.NoclipEnabled = false
            if flyConnection then flyConnection:Disconnect(); flyConnection = nil end
            if noclipConnection then noclipConnection:Disconnect(); noclipConnection = nil end
        end)

        -- ==================== FINAL NOTIFICATION ====================
        notify("Abyss UI", "Script loaded successfully! Press X to toggle aimbot.", 5)
        print("[Abyss UI] Loaded! | Press X to toggle aimbot")
