-- Abyss UI (Uma Racing) | By tze
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/orialdev/WindUI-Boreal/main/WindUI%20Boreal"))()

local Window = WindUI:CreateWindow({
    Title  = "Abyss UI",
    Author = "tze",
    Folder = "AbyssUI_UmaRacing",
    Icon   = "ghost-2",
    IconThemed = true,

    Theme  = "Midnight",
    Size   = UDim2.fromOffset(720, 540),
    Transparent = false,
    Acrylic     = false,
    SideBarWidth          = 210,
    ScrollBarEnabled      = true,
    HideSearchBar         = false,
    Resizable             = true,
    ModernLayout          = true,
    ModernLayoutMergeElements = false,

    User = {
        Enabled   = true,
        Anonymous = false,
        Callback  = function()
            WindUI:Notify({
                Title    = "Abyss UI",
                Content  = "Made by tze.",
                Icon     = "ghost-2",
                Duration = 4,
            })
        end,
    },

    Topbar = {
        Height      = 52,
        ButtonsType = "Default",
    },

    OpenButton = {
        Enabled  = true,
        Title    = "Abyss UI",
        Icon     = "ghost-2",
        Position = UDim2.new(0, 80, 0.5, 0),
        Draggable   = true,
        OnlyMobile  = false,
        Scale       = 1,
    },

    Watermark = {
        Enabled  = true,
        Text     = "Abyss UI — Uma Racing",
        Position = "bottom-right",
        Opacity  = 0.45,
        Size     = 13,
    },
})

-- ── Shortcut ──────────────────────────────────────────────────────────────────
Window:BindShortcut("RightAlt", function()
    Window:Toggle()
end, {
    Description      = "Toggle Abyss UI",
    EnabledWhenClosed = true,
})

-- ── Tags ──────────────────────────────────────────────────────────────────────
Window:Tag({
    Title = "v1",
    Color = Color3.fromRGB(248, 155, 41),
    Icon  = "badge-check",
})

Window:Tag({
    Title = "tze",
    Color = Color3.fromRGB(48, 255, 106),
    Icon  = "ghost-2",
})

-- ── Sidebar ───────────────────────────────────────────────────────────────────
Window:SideBarLabel({ Title = "Quick Actions", Icon = "zap" })

Window:SideBarButton({
    Title    = "Discord",
    Icon     = "message-circle",
    Variant  = "Secondary",
    Callback = function()
        setclipboard("tze")
        WindUI:Notify({ Title = "Discord", Content = "Copied 'tze' to clipboard.", Icon = "check", Duration = 3 })
    end,
})

Window:SideBarButton({
    Title    = "Server Invite",
    Icon     = "link",
    Variant  = "Secondary",
    Callback = function()
        setclipboard("https://discord.gg/PDgxSkhNtD")
        WindUI:Notify({ Title = "Discord", Content = "Invite copied to clipboard.", Icon = "check", Duration = 3 })
    end,
})

Window:SideBarDivider({})

-- ── Services ──────────────────────────────────────────────────────────────────
local Players = game:GetService("Players")
local player  = Players.LocalPlayer

local function notify(title, content, icon, duration)
    WindUI:Notify({
        Title    = title,
        Content  = content,
        Icon     = icon or "info",
        Duration = duration or 3,
    })
end

-- ═════════════════════════════════════════════════════════════════════════════
-- TABS
-- ═════════════════════════════════════════════════════════════════════════════
local HomeTab = Window:Tab({ Title = "Home",    Icon = "house",   ShowTabTitle = true, Border = true })
local MainTab = Window:Tab({ Title = "Main",    Icon = "gauge",   ShowTabTitle = true, Border = true })
local InfoTab = Window:Tab({ Title = "Info",    Icon = "info",    ShowTabTitle = true, Border = true })

Window:SelectTab(HomeTab)

-- ═════════════════════════════════════════════════════════════════════════════
-- HOME TAB
-- ═════════════════════════════════════════════════════════════════════════════
HomeTab:Paragraph({
    Title = "Welcome to Abyss UI",
    Desc  = "Script made by tze. Join the Discord Server in the Info tab for updates and suggestions.",
    Buttons = {
        {
            Title    = "Discord",
            Icon     = "message-circle",
            Callback = function()
                setclipboard("https://discord.gg/PDgxSkhNtD")
                notify("Discord", "Invite copied!", "check", 3)
            end,
        },
    },
})

HomeTab:Divider({})

HomeTab:Stats({
    Title = "Session Info",
    Desc  = "Live info about this session.",
    Items = {
        { Key = "Script",  Value = "Uma Racing"   },
        { Key = "Version", Value = "v1"         },
        { Key = "Author",  Value = "tze"        },
        { Key = "Toggle",  Value = "Right Alt"  },
    },
})

HomeTab:Code({
    Title = "Loader",
    Code  = [[loadstring(game:HttpGet("https://raw.githubusercontent.com/jonathabejose-alt/AbyssUI/refs/heads/main/loander1"))()]],
    OnCopy = function()
        notify("Loader", "Copied loader to clipboard.", "copy", 3)
    end,
})

-- ═════════════════════════════════════════════════════════════════════════════
-- MAIN TAB
-- ═════════════════════════════════════════════════════════════════════════════

-- ── State variables ───────────────────────────────────────────────────────────
local FVelocity = Vector3.new(0, 0, 0)
local ECSetting = false
local ISSetting = false
local VMSetting = 1

-- ── Hooks (se ejecutan una sola vez al cargar) ────────────────────────────────
local oldindex; oldindex = hookmetamethod(game, "__index", function(v1, v2)
    if ECSetting and v2 == "Velocity" and getnamecallmethod() == "ToOrientation" then
        return FVelocity
    end
    return oldindex(v1, v2)
end)

local function SmoothVelocity(velocity)
    if velocity > 250 or math.random(1, 7) == 1 then
        return 1
    end
    return velocity * VMSetting
end

local oldnewindex; oldnewindex = hookmetamethod(game, "__newindex", function(v1, v2, v3)
    if v2 == "AssemblyLinearVelocity" then
        return oldnewindex(v1, v2, v3.Unit * SmoothVelocity(math.abs(v3.Magnitude)))
    end
    return oldnewindex(v1, v2, v3)
end)

local oldnamecall; oldnamecall = hookmetamethod(game, "__namecall", function(v1, v2, ...)
    if ISSetting and getnamecallmethod() == "FireServer" and v2 == "SpeedTarget" then
        return oldnamecall(v1, v2, 0)
    end
    return oldnamecall(v1, v2, ...)
end)

-- ── UI ────────────────────────────────────────────────────────────────────────
local mainSection = MainTab:Section({
    Title     = "Movement Features",
    Desc      = "Controls for velocity and stamina.",
    Icon      = "gauge",
    Opened    = true,
    Box       = true,
    BoxBorder = true,
})

mainSection:Toggle({
    Title = "Easy Control",
    Desc  = "Smooths out velocity orientation so movement feels easier to control.",
    Icon  = "joystick",
    Type  = "Toggle",
    Value = false,
    Callback = function(state)
        ECSetting = state
        notify("Easy Control", state and "Enabled." or "Disabled.", "joystick")
    end,
})

mainSection:Toggle({
    Title = "Infinity Stamina",
    Desc  = "Prevents the game from reducing your stamina via server calls.",
    Icon  = "battery-charging",
    Type  = "Toggle",
    Value = false,
    Callback = function(state)
        ISSetting = state
        notify("Infinity Stamina", state and "Enabled." or "Disabled.", "battery-charging")
    end,
})

mainSection:Divider({})

mainSection:Slider({
    Title     = "Velocity Multiplier",
    Desc      = "Multiplies your AssemblyLinearVelocity. 1 = normal, 3 = max.",
    Icon      = "gauge",
    Value     = { Min = 1, Max = 3, Default = 1 },
    Step      = 0.1,
    IsTextbox = true,
    IsTooltip = true,
    Suffix    = "x",
    Callback  = function(value)
        VMSetting = value
        notify("Velocity Multiplier", "Set to " .. tostring(value) .. "x", "gauge")
    end,
})

-- ═════════════════════════════════════════════════════════════════════════════
-- INFO TAB
-- ═════════════════════════════════════════════════════════════════════════════
InfoTab:Paragraph({
    Title = "Keybinds",
    Desc  = "Show / Hide GUI: Right Alt",
})

InfoTab:Divider({})

local infoGroup = InfoTab:Group({})

infoGroup:Button({
    Title    = "Copy Owner Discord",
    Desc     = "Copies 'tze' to clipboard.",
    Icon     = "copy",
    Callback = function()
        setclipboard("tze")
        notify("Discord", "Copied username!", "check", 3)
    end,
})

infoGroup:Button({
    Title    = "Copy Server Invite",
    Desc     = "Copies the invite link to clipboard.",
    Icon     = "link",
    Callback = function()
        setclipboard("https://discord.gg/PDgxSkhNtD")
        notify("Discord", "Copied invite!", "check", 3)
    end,
})

-- ═════════════════════════════════════════════════════════════════════════════
-- NOTIFY ON LOAD
-- ═════════════════════════════════════════════════════════════════════════════
WindUI:Notify({
    Title    = "Abyss UI",
    Content  = "Uma Racing loaded successfully.",
    Icon     = "check",
    Duration = 5,
})
