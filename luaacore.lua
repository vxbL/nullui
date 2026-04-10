local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui   = LocalPlayer:WaitForChild("PlayerGui")

if PlayerGui:FindFirstChild("LuaCoreGUI") then
    PlayerGui.LuaCoreGUI:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name           = "LuaCoreGUI"
ScreenGui.ResetOnSpawn   = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder   = 99
ScreenGui.Parent         = PlayerGui

local function ni(cls, t)
    local o = Instance.new(cls)
    for k, v in pairs(t) do o[k] = v end
    return o
end
local function tw(o, i, p) TweenService:Create(o, i, p):Play() end

local FAST   = TweenInfo.new(0.14, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local MED    = TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local SNAP   = TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local SLOW   = TweenInfo.new(0.32, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local SPRING = TweenInfo.new(0.30, Enum.EasingStyle.Back,  Enum.EasingDirection.Out)
local EASE   = TweenInfo.new(0.20, Enum.EasingStyle.Sine,  Enum.EasingDirection.Out)

local C = {
    bg      = Color3.fromRGB(14, 14, 14),
    panel   = Color3.fromRGB(19, 19, 19),
    card    = Color3.fromRGB(23, 23, 23),
    border  = Color3.fromRGB(46, 46, 46),
    white   = Color3.fromRGB(255, 255, 255),
    w75     = Color3.fromRGB(190, 190, 190),
    w50     = Color3.fromRGB(128, 128, 128),
    w25     = Color3.fromRGB(65, 65, 65),
    w12     = Color3.fromRGB(32, 32, 32),
    vbox    = Color3.fromRGB(26, 26, 26),
    ddBg    = Color3.fromRGB(20, 20, 20),
    ddRow   = Color3.fromRGB(28, 28, 28),
    ddHov   = Color3.fromRGB(40, 40, 40),
    scrollC = Color3.fromRGB(58, 58, 58),
    green   = Color3.fromRGB(30, 90, 30),
    gtext   = Color3.fromRGB(80, 200, 80),
    blue    = Color3.fromRGB(25, 50, 90),
    red     = Color3.fromRGB(90, 28, 28),
    rtext   = Color3.fromRGB(220, 90, 90),
    listen  = Color3.fromRGB(255, 200, 60),
}

local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

local GUI_W, GUI_H, SIDEBAR_W, HEADER_H
if isMobile then
    GUI_W     = 500
    GUI_H     = 290
    SIDEBAR_W = 80
    HEADER_H  = 36
else
    GUI_W     = 920
    GUI_H     = 620
    SIDEBAR_W = 210
    HEADER_H  = 54
end

local PAD   = isMobile and 5  or 8
local SB_W  = 4
local INNER = isMobile and 9  or 14

local RH_T  = isMobile and 34 or 46
local RH_S  = isMobile and 50 or 62
local RH_DD = isMobile and 38 or 50
local RH_I  = isMobile and 26 or 34
local RH_B  = isMobile and 32 or 42
local RH_KB = isMobile and 38 or 48
local DD_TP = 5
local DD_G  = 2
local SEC_H = isMobile and 24 or 32
local SEC_G = isMobile and 6  or 10
local BOT   = isMobile and 8  or 12

local TS_SM  = isMobile and 8  or 10
local TS_MED = isMobile and 10 or 12
local TS_LG  = isMobile and 11 or 14
local TS_XL  = isMobile and 14 or 26

local liveState   = {}
local liveSetters = {}

local Main = ni("Frame", {
    Name             = "MainFrame",
    Size             = UDim2.new(0, GUI_W, 0, GUI_H),
    Position         = UDim2.new(0.5, -GUI_W / 2, 0.5, -GUI_H / 2),
    BackgroundColor3 = C.bg,
    BorderSizePixel  = 0,
    ClipsDescendants = true,
    Parent           = ScreenGui,
})
ni("UICorner", { CornerRadius = UDim.new(0, isMobile and 10 or 14), Parent = Main })
ni("UIStroke", { Color = C.border, Thickness = 1, Parent = Main })

local guiVisible = true
local function setVisible(v)
    guiVisible = v
    if v then
        Main.Visible = true
        Main.Size     = UDim2.new(0, GUI_W, 0, GUI_H * 0.92)
        Main.Position = UDim2.new(0.5, -GUI_W / 2, 0.5, -GUI_H / 2 + GUI_H * 0.04)
        tw(Main, TweenInfo.new(0.32, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size     = UDim2.new(0, GUI_W, 0, GUI_H),
            Position = UDim2.new(0.5, -GUI_W / 2, 0.5, -GUI_H / 2),
        })
    else
        tw(Main, TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
            Size     = UDim2.new(0, GUI_W, 0, GUI_H * 0.88),
            Position = UDim2.new(0.5, -GUI_W / 2, 0.5, -GUI_H / 2 + GUI_H * 0.06),
        })
        task.delay(0.18, function()
            if not guiVisible then
                tw(Main, TweenInfo.new(0.14, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
                    Size     = UDim2.new(0, GUI_W, 0, 0),
                    Position = UDim2.new(0.5, -GUI_W / 2, 0.5, 0),
                })
                task.delay(0.15, function()
                    if not guiVisible then Main.Visible = false end
                end)
            end
        end)
    end
end

UserInputService.InputBegan:Connect(function(i, gp)
    if gp then return end
    if i.KeyCode == Enum.KeyCode.LeftControl or i.KeyCode == Enum.KeyCode.LeftMeta then
        setVisible(not guiVisible)
    end
end)

do
    local drag, ds, dp
    Main.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1
            or i.UserInputType == Enum.UserInputType.Touch then
            drag = true; ds = i.Position; dp = Main.Position
        end
    end)
    Main.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1
            or i.UserInputType == Enum.UserInputType.Touch then drag = false end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if drag and (i.UserInputType == Enum.UserInputType.MouseMovement
            or i.UserInputType == Enum.UserInputType.Touch) then
            local d = i.Position - ds
            Main.Position = UDim2.new(dp.X.Scale, dp.X.Offset + d.X, dp.Y.Scale, dp.Y.Offset + d.Y)
        end
    end)
end

do
    local bgClip = ni("Frame", {
        Size                   = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        ZIndex                 = 1,
        ClipsDescendants       = true,
        Parent                 = Main,
    })
    ni("UICorner", { CornerRadius = UDim.new(0, isMobile and 10 or 14), Parent = bgClip })
    math.randomseed(77)
    local types   = { "circle", "square", "triangle" }
    local cols    = isMobile and 7 or 6
    local rows_bg = isMobile and 5 or 4
    local cw      = GUI_W / cols
    local ch      = GUI_H / rows_bg
    local margin  = isMobile and 16 or 28

    local function mline(par, x1, y1, x2, y2, a)
        local dx, dy = x2 - x1, y2 - y1
        local f = ni("Frame", {
            Size                   = UDim2.new(0, math.sqrt(dx * dx + dy * dy), 0, 2),
            Position               = UDim2.new(0, x1, 0, y1 - 1),
            Rotation               = math.deg(math.atan2(dy, dx)),
            BackgroundColor3       = C.white,
            BackgroundTransparency = a,
            BorderSizePixel        = 0,
            ZIndex                 = 2,
            Parent                 = par,
        })
        ni("UICorner", { CornerRadius = UDim.new(1, 0), Parent = f })
    end

    for r = 0, rows_bg - 1 do
        for c = 0, cols - 1 do
            local st   = types[math.random(1, 3)]
            local sz   = math.random(isMobile and 10 or 18, isMobile and 30 or 48)
            local half = sz / 2
            local px   = c * cw + cw * 0.5 + math.random(-5, 5)
            local py   = r * ch + ch * 0.5 + math.random(-5, 5)
            px = math.clamp(px, margin + half, GUI_W - margin - half)
            py = math.clamp(py, margin + half, GUI_H - margin - half)
            local a = 0.65 + math.random() * 0.23
            if st == "circle" or st == "square" then
                local f = ni("Frame", {
                    Size                   = UDim2.new(0, sz, 0, sz),
                    Position               = UDim2.new(0, px - half, 0, py - half),
                    BackgroundTransparency = 1,
                    ZIndex                 = 2,
                    Parent                 = bgClip,
                })
                if st == "circle" then ni("UICorner", { CornerRadius = UDim.new(1, 0), Parent = f }) end
                ni("UIStroke", { Color = C.white, Thickness = 1.3, Transparency = a, Parent = f })
            else
                local triH = sz * 0.87
                local triC = ni("Frame", {
                    Size                   = UDim2.new(0, sz, 0, triH),
                    Position               = UDim2.new(0, px - half, 0, py - triH / 2),
                    BackgroundTransparency = 1,
                    ClipsDescendants       = false,
                    Rotation               = math.random(0, 360),
                    ZIndex                 = 2,
                    Parent                 = bgClip,
                })
                mline(triC, sz / 2, 0, sz, triH, a)
                mline(triC, sz, triH, 0, triH, a)
                mline(triC, 0, triH, sz / 2, 0, a)
            end
        end
    end
end

local Header = ni("Frame", {
    Size             = UDim2.new(1, 0, 0, HEADER_H),
    BackgroundColor3 = C.panel,
    BorderSizePixel  = 0,
    ZIndex           = 5,
    Parent           = Main,
})
ni("UICorner", { CornerRadius = UDim.new(0, isMobile and 10 or 14), Parent = Header })
ni("Frame", {
    Size             = UDim2.new(1, 0, 0, 14),
    Position         = UDim2.new(0, 0, 1, -14),
    BackgroundColor3 = C.panel,
    BorderSizePixel  = 0,
    ZIndex           = 5,
    Parent           = Header,
})
ni("Frame", {
    Size             = UDim2.new(1, 0, 0, 1),
    Position         = UDim2.new(0, 0, 1, 0),
    BackgroundColor3 = C.border,
    BorderSizePixel  = 0,
    ZIndex           = 6,
    Parent           = Header,
})

local logoSz  = math.floor(HEADER_H * 0.55)
local LogoBox = ni("Frame", {
    Size                   = UDim2.new(0, logoSz, 0, logoSz),
    Position               = UDim2.new(0, isMobile and 8 or 12, 0.5, -logoSz / 2),
    BackgroundTransparency = 1,
    ZIndex                 = 7,
    Parent                 = Header,
})
ni("ImageLabel", {
    Size                   = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Image                  = "rbxassetid://112326774527295",
    ScaleType              = Enum.ScaleType.Fit,
    ZIndex                 = 8,
    Parent                 = LogoBox,
})
ni("TextLabel", {
    Size                   = UDim2.new(0, isMobile and 80 or 160, 0, HEADER_H),
    Position               = UDim2.new(0, logoSz + (isMobile and 7 or 16), 0, 0),
    BackgroundTransparency = 1,
    Text                   = "LuaCore",
    TextColor3             = C.white,
    Font                   = Enum.Font.GothamBold,
    TextSize               = TS_XL,
    TextXAlignment         = Enum.TextXAlignment.Left,
    ZIndex                 = 7,
    Parent                 = Header,
})


local Body = ni("Frame", {
    Size                   = UDim2.new(1, 0, 1, -HEADER_H),
    Position               = UDim2.new(0, 0, 0, HEADER_H),
    BackgroundTransparency = 1,
    ZIndex                 = 4,
    Parent                 = Main,
})

local Sidebar = ni("Frame", {
    Size             = UDim2.new(0, SIDEBAR_W, 1, -PAD * 2),
    Position         = UDim2.new(0, PAD, 0, PAD),
    BackgroundColor3 = C.panel,
    ZIndex           = 5,
    Parent           = Body,
})
ni("UICorner", { CornerRadius = UDim.new(0, isMobile and 7 or 10), Parent = Sidebar })
ni("UIStroke", { Color = C.border, Thickness = 1, Parent = Sidebar })

local SideList = ni("Frame", {
    Size                   = UDim2.new(1, -6, 1, -6),
    Position               = UDim2.new(0, 3, 0, 3),
    BackgroundTransparency = 1,
    ZIndex                 = 6,
    Parent                 = Sidebar,
})
ni("UIListLayout", {
    SortOrder = Enum.SortOrder.LayoutOrder,
    Padding   = UDim.new(0, 2),
    Parent    = SideList,
})

local tabFrames   = {}
local tabBtns     = {}
local currentTab  = nil
local openOverlay = nil

local CONTENT_X = PAD + SIDEBAR_W + PAD
local SCROLL_W  = GUI_W - CONTENT_X - PAD

local ScrollFrame = ni("ScrollingFrame", {
    Size                 = UDim2.new(0, SCROLL_W, 1, -PAD * 2),
    Position             = UDim2.new(0, CONTENT_X, 0, PAD),
    BackgroundTransparency = 1,
    BorderSizePixel      = 0,
    ZIndex               = 4,
    ScrollBarThickness   = isMobile and 2 or SB_W,
    ScrollBarImageColor3 = C.scrollC,
    CanvasSize           = UDim2.new(0, 0, 0, 0),
    ScrollingDirection   = Enum.ScrollingDirection.Y,
    ElasticBehavior      = Enum.ElasticBehavior.WhenScrollable,
    ClipsDescendants     = true,
    Parent               = Body,
})

local ContentInner = ni("Frame", {
    Size                   = UDim2.new(1, isMobile and -2 or (-SB_W - 2), 1, 0),
    BackgroundTransparency = 1,
    ZIndex                 = 5,
    Parent                 = ScrollFrame,
})

local OverlayLayer = ni("Frame", {
    Size                   = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    ZIndex                 = 200,
    Parent                 = ScreenGui,
})

local TAB_CANVAS    = {}
local _switchBusy   = false
local _pendingSwitch = nil

local function switchTab(name)
    if currentTab == name then return end
    if _switchBusy then _pendingSwitch = name; return end
    _switchBusy = true

    local prevName   = currentTab
    local prevCanvas = prevName and tabFrames[prevName]
    local nextCanvas = tabFrames[name]

    currentTab = name

    for n, b in pairs(tabBtns) do
        local ac  = b:FindFirstChild("Accent")
        local ico = b:FindFirstChild("TabIcon")
        local lbl = b:FindFirstChild("TabLabel")
        if ac  then tw(ac,  FAST, { BackgroundTransparency = n == name and 0 or 1 }) end
        if ico then tw(ico, FAST, { ImageColor3 = n == name and C.white or C.w50 }) end
        if lbl then lbl.TextColor3 = n == name and C.white or C.w75 end
        tw(b, FAST, {
            BackgroundTransparency = n == name and 0.78 or 1,
            BackgroundColor3       = n == name and Color3.fromRGB(36, 36, 36) or C.panel,
        })
    end

    if openOverlay then openOverlay(); openOverlay = nil end

    ScrollFrame.CanvasSize     = UDim2.new(0, 0, 0, TAB_CANVAS[name] or 0)
    ScrollFrame.CanvasPosition = Vector2.new(0, 0)

    if prevCanvas and prevCanvas.Visible then
        tw(prevCanvas, EASE, { GroupTransparency = 1 })
        task.delay(0.20, function()
            prevCanvas.Visible           = false
            prevCanvas.GroupTransparency = 0
        end)
    end

    nextCanvas.GroupTransparency = 1
    nextCanvas.Visible           = true
    task.delay(0.05, function()
        tw(nextCanvas, MED, { GroupTransparency = 0 })
        task.delay(0.26, function()
            _switchBusy = false
            if _pendingSwitch then
                local p = _pendingSwitch
                _pendingSwitch = nil
                switchTab(p)
            end
        end)
    end)
end

local function makeArrow(parent, z)
    local c = ni("Frame", {
        Size                   = UDim2.new(0, 9, 0, 5),
        Position               = UDim2.new(0.5, -4, 0.5, -2),
        BackgroundTransparency = 1,
        ZIndex                 = z,
        Parent                 = parent,
    })
    local function arm(rot)
        local a = ni("Frame", {
            Size             = UDim2.new(0, 5, 0, 2),
            Position         = rot > 0 and UDim2.new(0, 0, .5, -1) or UDim2.new(1, -5, .5, -1),
            Rotation         = rot,
            BackgroundColor3 = C.w50,
            BorderSizePixel  = 0,
            ZIndex           = z + 1,
            Parent           = c,
        })
        ni("UICorner", { CornerRadius = UDim.new(1, 0), Parent = a })
    end
    arm(36); arm(-36)
    return c
end

local LuaCore = {}
local Window  = {}
Window.__index = Window

function LuaCore:CreateWindow(config)
    local windowName = config.Name or "LuaCore"
    local windowIcon = config.Icon
    if windowIcon then
        local logoImg = LogoBox:FindFirstChildOfClass("ImageLabel")
        if logoImg then
            logoImg.Image = type(windowIcon) == "number"
                and ("rbxassetid://" .. tostring(windowIcon))
                or tostring(windowIcon)
        end
    end
    local win = setmetatable({}, Window)
    win._tabOrder = 0
    return win
end

function Window:CreateTab(name, icon)
    self._tabOrder = (self._tabOrder or 0) + 1
    local order = self._tabOrder
    local TAB_H = isMobile and 28 or 44

    local btn = ni("TextButton", {
        Name                   = name,
        Size                   = UDim2.new(1, 0, 0, TAB_H),
        BackgroundColor3       = C.panel,
        BackgroundTransparency = 1,
        Text                   = "",
        AutoButtonColor        = false,
        ZIndex                 = 7,
        LayoutOrder            = order,
        Parent                 = SideList,
    })
    ni("UICorner", { CornerRadius = UDim.new(0, 6), Parent = btn })
    ni("Frame", {
        Name                   = "Accent",
        Size                   = UDim2.new(0, 3, 0.5, 0),
        Position               = UDim2.new(0, 0, 0.25, 0),
        BackgroundColor3       = C.white,
        BackgroundTransparency = 1,
        ZIndex                 = 8,
        Parent                 = btn,
    })
    ni("UICorner", { CornerRadius = UDim.new(1, 0), Parent = btn:FindFirstChild("Accent") })

    if not isMobile then
        local iconImage = icon
            and (type(icon) == "number" and ("rbxassetid://" .. tostring(icon)) or tostring(icon))
            or "rbxassetid://7733960981"
        ni("ImageLabel", {
            Name                   = "TabIcon",
            Size                   = UDim2.new(0, 16, 0, 16),
            Position               = UDim2.new(0, 10, 0.5, -8),
            BackgroundTransparency = 1,
            Image                  = iconImage,
            ImageColor3            = C.w50,
            ZIndex                 = 8,
            Parent                 = btn,
        })
    end

    local lblX = isMobile and 7 or 32
    ni("TextLabel", {
        Name                   = "TabLabel",
        Size                   = UDim2.new(1, -lblX - 3, 1, 0),
        Position               = UDim2.new(0, lblX, 0, 0),
        BackgroundTransparency = 1,
        Text                   = name,
        TextColor3             = C.w75,
        Font                   = Enum.Font.GothamMedium,
        TextSize               = TS_MED,
        TextXAlignment         = Enum.TextXAlignment.Left,
        ZIndex                 = 8,
        Parent                 = btn,
    })

    tabBtns[name] = btn
    btn.MouseEnter:Connect(function()
        if currentTab ~= name then tw(btn, FAST, { BackgroundTransparency = 0.88 }) end
    end)
    btn.MouseLeave:Connect(function()
        if currentTab ~= name then tw(btn, FAST, { BackgroundTransparency = 1 }) end
    end)
    btn.MouseButton1Click:Connect(function() switchTab(name) end)

    local tabCanvas = Instance.new("CanvasGroup")
    tabCanvas.Size                   = UDim2.new(1, 0, 0, 0)
    tabCanvas.BackgroundTransparency = 1
    tabCanvas.GroupTransparency      = 1
    tabCanvas.BorderSizePixel        = 0
    tabCanvas.ZIndex                 = 7
    tabCanvas.Visible                = false
    tabCanvas.Parent                 = ContentInner

    local tabFrame = ni("Frame", {
        Size                   = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        ZIndex                 = 7,
        Parent                 = tabCanvas,
    })
    tabFrames[name] = tabCanvas

    ni("TextLabel", {
        Size                   = UDim2.new(1, 0, 0, isMobile and 22 or 34),
        Position               = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        Text                   = name,
        TextColor3             = C.white,
        Font                   = Enum.Font.GothamBold,
        TextSize               = isMobile and 13 or 21,
        TextXAlignment         = Enum.TextXAlignment.Left,
        ZIndex                 = 8,
        Parent                 = tabFrame,
    })

    local rowList  = {}
    local cursor   = isMobile and 26 or 38
    local sections = {}
    TAB_CANVAS[name] = cursor

    local function updateCanvas()
        local last   = rowList[#rowList]
        local totalH = last and (last.y + last.h + 10) or cursor + 4
        TAB_CANVAS[name] = totalH
        tabFrame.Size    = UDim2.new(1, 0, 0, totalH)
        tabCanvas.Size   = UDim2.new(1, 0, 0, totalH)
        if currentTab == name then
            ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, totalH)
        end
    end

    local Tab = {}
    Tab.__index = Tab

    function Tab:CreateSection(sectionName)
        local gap = ni("Frame", {
            Size                   = UDim2.new(1, 0, 0, SEC_G),
            Position               = UDim2.new(0, 0, 0, cursor),
            BackgroundTransparency = 1,
            ZIndex                 = 8,
            Parent                 = tabFrame,
        })
        rowList[#rowList + 1] = { frame = gap, h = SEC_G, y = cursor }
        cursor = cursor + SEC_G

        local secFirstRowIdx = #rowList + 1
        local bg = ni("Frame", {
            Position         = UDim2.new(0, 0, 0, cursor),
            Size             = UDim2.new(1, 0, 0, 0),
            BackgroundColor3 = C.card,
            ZIndex           = 8,
            Parent           = tabFrame,
        })
        ni("UICorner", { CornerRadius = UDim.new(0, isMobile and 7 or 10), Parent = bg })
        ni("UIStroke", { Color = C.border, Thickness = 1, Parent = bg })

        local h      = SEC_H + 1
        local titleF = ni("Frame", {
            Size                   = UDim2.new(1, 0, 0, h),
            Position               = UDim2.new(0, 0, 0, cursor),
            BackgroundTransparency = 1,
            ZIndex                 = 9,
            Parent                 = tabFrame,
        })
        rowList[#rowList + 1] = { frame = titleF, h = h, y = cursor }
        cursor = cursor + h

        ni("TextLabel", {
            Size                   = UDim2.new(1, -INNER * 2, 0, SEC_H),
            Position               = UDim2.new(0, INNER, 0, 0),
            BackgroundTransparency = 1,
            Text                   = sectionName,
            TextColor3             = C.w50,
            Font                   = Enum.Font.GothamBold,
            TextSize               = TS_SM,
            TextXAlignment         = Enum.TextXAlignment.Left,
            ZIndex                 = 10,
            Parent                 = titleF,
        })
        ni("Frame", {
            Size             = UDim2.new(1, -INNER * 2, 0, 1),
            Position         = UDim2.new(0, INNER, 0, SEC_H),
            BackgroundColor3 = C.border,
            ZIndex           = 10,
            Parent           = titleF,
        })

        local sec = { bg = bg, firstRow = secFirstRowIdx, lastRow = 0 }
        sections[#sections + 1] = sec

        local SectionObj = {}
        function SectionObj:Set(newName)
            local lbl = titleF:FindFirstChildWhichIsA("TextLabel")
            if lbl then lbl.Text = newName end
        end
        function SectionObj:_close()
            sec.lastRow = #rowList
            local fR    = rowList[sec.firstRow]
            local lR    = rowList[sec.lastRow]
            sec.bg.Position = UDim2.new(0, 0, 0, fR.y)
            sec.bg.Size     = UDim2.new(1, 0, 0, lR.y + lR.h + BOT - fR.y)
            cursor = lR.y + lR.h + BOT + SEC_G
            updateCanvas()
        end
        return SectionObj
    end

    function Tab:CreateButton(config)
        local label    = config.Name or "Button"
        local callback = config.Callback or function() end
        local h        = RH_B
        local f        = ni("Frame", {
            Size                   = UDim2.new(1, 0, 0, h),
            Position               = UDim2.new(0, 0, 0, cursor),
            BackgroundTransparency = 1,
            ZIndex                 = 9,
            Parent                 = tabFrame,
        })
        rowList[#rowList + 1] = { frame = f, h = h, y = cursor }
        cursor = cursor + h

        local bh       = math.floor(h * 0.75)
        local btnFrame = ni("Frame", {
            Size             = UDim2.new(1, -INNER * 2, 0, bh),
            Position         = UDim2.new(0, INNER, 0.5, -bh / 2),
            BackgroundColor3 = C.w12,
            ZIndex           = 10,
            Parent           = f,
        })
        ni("UICorner", { CornerRadius = UDim.new(0, 5), Parent = btnFrame })
        ni("UIStroke", { Color = C.border, Thickness = 1, Parent = btnFrame })
        ni("TextLabel", {
            Size                   = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Text                   = label,
            TextColor3             = C.white,
            Font                   = Enum.Font.GothamBold,
            TextSize               = TS_MED,
            ZIndex                 = 11,
            Parent                 = btnFrame,
        })
        local hit = ni("TextButton", {
            Size                   = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Text                   = "",
            ZIndex                 = 12,
            Parent                 = btnFrame,
        })
        hit.MouseEnter:Connect(function()
            tw(btnFrame, FAST, { BackgroundColor3 = Color3.fromRGB(42, 42, 42) })
            tw(btnFrame:FindFirstChildOfClass("UIStroke") or Instance.new("UIStroke"), FAST, { Color = C.w25 })
        end)
        hit.MouseLeave:Connect(function()
            tw(btnFrame, FAST, { BackgroundColor3 = C.w12 })
            local s = btnFrame:FindFirstChildOfClass("UIStroke")
            if s then tw(s, FAST, { Color = C.border }) end
        end)
        hit.MouseButton1Click:Connect(function()
            tw(btnFrame, TweenInfo.new(0.07, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
                { BackgroundColor3 = Color3.fromRGB(68, 68, 68) })
            local s = btnFrame:FindFirstChildOfClass("UIStroke")
            if s then tw(s, FAST, { Color = C.white }) end
            task.delay(0.14, function()
                tw(btnFrame, MED, { BackgroundColor3 = C.w12 })
                if s then tw(s, MED, { Color = C.border }) end
            end)
            task.spawn(callback)
        end)
        updateCanvas()
        local BtnObj = {}
        function BtnObj:Set(newName)
            local lbl = btnFrame:FindFirstChildWhichIsA("TextLabel")
            if lbl then lbl.Text = newName end
        end
        return BtnObj
    end

    function Tab:CreateToggle(config)
        local label    = config.Name or "Toggle"
        local default  = config.CurrentValue ~= nil and config.CurrentValue or false
        local callback = config.Callback or function() end
        local key      = name .. "/" .. label
        local h        = RH_T
        local f        = ni("Frame", {
            Size                   = UDim2.new(1, 0, 0, h),
            Position               = UDim2.new(0, 0, 0, cursor),
            BackgroundTransparency = 1,
            ZIndex                 = 9,
            Parent                 = tabFrame,
        })
        rowList[#rowList + 1] = { frame = f, h = h, y = cursor }
        cursor = cursor + h

        ni("TextLabel", {
            Size                   = UDim2.new(1, -60, 1, 0),
            Position               = UDim2.new(0, INNER, 0, 0),
            BackgroundTransparency = 1,
            Text                   = label,
            TextColor3             = C.w75,
            Font                   = Enum.Font.GothamMedium,
            TextSize               = TS_MED,
            TextXAlignment         = Enum.TextXAlignment.Left,
            ZIndex                 = 10,
            Parent                 = f,
        })

        local TRK_W = isMobile and 30 or 46
        local TRK_H = isMobile and 16 or 24
        local THB   = isMobile and 11 or 18
        local offX  = 3
        local onX   = TRK_W - THB - 3

        local track = ni("Frame", {
            Size             = UDim2.new(0, TRK_W, 0, TRK_H),
            Position         = UDim2.new(1, -INNER - TRK_W, 0.5, -TRK_H / 2),
            BackgroundColor3 = default and C.white or C.w12,
            ZIndex           = 10,
            Parent           = f,
        })
        ni("UICorner", { CornerRadius = UDim.new(1, 0), Parent = track })
        local thumb = ni("Frame", {
            Size             = UDim2.new(0, THB, 0, THB),
            Position         = default and UDim2.new(0, onX, 0.5, -THB / 2) or UDim2.new(0, offX, 0.5, -THB / 2),
            BackgroundColor3 = default and Color3.fromRGB(16, 16, 16) or C.white,
            ZIndex           = 11,
            Parent           = track,
        })
        ni("UICorner", { CornerRadius = UDim.new(1, 0), Parent = thumb })

        local on = default
        liveState[key] = default

        local toggleLabel = f:FindFirstChildWhichIsA("TextLabel")

        local function applyToggle(v)
            on = v; liveState[key] = v
            tw(track, MED, { BackgroundColor3 = on and C.white or C.w12 })
            tw(thumb, SNAP, {
                Position         = on and UDim2.new(0, onX, 0.5, -THB / 2) or UDim2.new(0, offX, 0.5, -THB / 2),
                BackgroundColor3 = on and Color3.fromRGB(16, 16, 16) or C.white,
                Size             = UDim2.new(0, THB, 0, THB),
            })
            if toggleLabel then
                tw(toggleLabel, EASE, { TextColor3 = on and C.white or C.w75 })
            end
            task.spawn(callback, v)
        end
        liveSetters[key] = applyToggle

        local hitArea = ni("TextButton", {
            Size                   = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Text                   = "",
            ZIndex                 = 12,
            Parent                 = f,
        })
        hitArea.MouseEnter:Connect(function()
            tw(thumb, FAST, { Size = UDim2.new(0, THB + (isMobile and 1 or 2), 0, THB + (isMobile and 1 or 2)) })
        end)
        hitArea.MouseLeave:Connect(function()
            tw(thumb, FAST, { Size = UDim2.new(0, THB, 0, THB) })
        end)
        hitArea.MouseButton1Click:Connect(function() applyToggle(not on) end)
        updateCanvas()

        local ToggleObj = {}
        function ToggleObj:Set(v)     applyToggle(v) end
        function ToggleObj:GetState() return on end
        return ToggleObj
    end

    function Tab:CreateSlider(config)
        local label    = config.Name or "Slider"
        local range    = config.Range or { 0, 100 }
        local minV     = range[1]
        local maxV     = range[2]
        local incr     = config.Increment or 1
        local suffix   = config.Suffix or ""
        local default  = config.CurrentValue or minV
        local callback = config.Callback or function() end
        local key      = name .. "/" .. label

        local h = RH_S
        local f = ni("Frame", {
            Size                   = UDim2.new(1, 0, 0, h),
            Position               = UDim2.new(0, 0, 0, cursor),
            BackgroundTransparency = 1,
            ZIndex                 = 9,
            Parent                 = tabFrame,
        })
        rowList[#rowList + 1] = { frame = f, h = h, y = cursor }
        cursor = cursor + h

        local STEP_W = isMobile and 18 or 26
        local VAL_W  = isMobile and 40 or 60
        local CTRL_W = STEP_W + 3 + VAL_W + 3 + STEP_W
        local CTRL_H = isMobile and 20 or 26
        local CTRL_Y = isMobile and 5  or 9
        local TRK_Y  = isMobile and 30 or 42
        local KNB    = isMobile and 14 or 15

        ni("TextLabel", {
            Size                   = UDim2.new(1, -(INNER + CTRL_W + INNER + 6), 0, 14),
            Position               = UDim2.new(0, INNER, 0, isMobile and 6 or 10),
            BackgroundTransparency = 1,
            Text                   = label,
            TextColor3             = C.w50,
            Font                   = Enum.Font.GothamBold,
            TextSize               = TS_SM,
            TextXAlignment         = Enum.TextXAlignment.Left,
            ZIndex                 = 10,
            Parent                 = f,
        })

        local stepMinus = ni("TextButton", {
            Size             = UDim2.new(0, STEP_W, 0, CTRL_H),
            Position         = UDim2.new(1, -INNER - CTRL_W, 0, CTRL_Y),
            BackgroundColor3 = C.w12,
            AutoButtonColor  = false,
            Text             = "−",
            TextColor3       = C.w75,
            Font             = Enum.Font.GothamBold,
            TextSize         = TS_LG,
            ZIndex           = 11,
            Parent           = f,
        })
        ni("UICorner", { CornerRadius = UDim.new(0, 4), Parent = stepMinus })
        ni("UIStroke", { Color = C.border, Thickness = 1, Parent = stepMinus })

        local vF = ni("Frame", {
            Size             = UDim2.new(0, VAL_W, 0, CTRL_H),
            Position         = UDim2.new(1, -INNER - CTRL_W + STEP_W + 3, 0, CTRL_Y),
            BackgroundColor3 = C.vbox,
            ZIndex           = 10,
            Parent           = f,
        })
        ni("UICorner", { CornerRadius = UDim.new(0, 4), Parent = vF })
        ni("UIStroke", { Color = C.border, Thickness = 1, Parent = vF })
        local vBox = ni("TextBox", {
            Size                   = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Text                   = tostring(default) .. (suffix ~= "" and " " .. suffix or ""),
            TextColor3             = C.white,
            Font                   = Enum.Font.Code,
            TextSize               = TS_SM,
            ClearTextOnFocus       = false,
            ZIndex                 = 11,
            Parent                 = vF,
        })

        local stepPlus = ni("TextButton", {
            Size             = UDim2.new(0, STEP_W, 0, CTRL_H),
            Position         = UDim2.new(1, -INNER - STEP_W, 0, CTRL_Y),
            BackgroundColor3 = C.w12,
            AutoButtonColor  = false,
            Text             = "+",
            TextColor3       = C.w75,
            Font             = Enum.Font.GothamBold,
            TextSize         = TS_LG,
            ZIndex           = 11,
            Parent           = f,
        })
        ni("UICorner", { CornerRadius = UDim.new(0, 4), Parent = stepPlus })
        ni("UIStroke", { Color = C.border, Thickness = 1, Parent = stepPlus })

        local trk = ni("Frame", {
            Size             = UDim2.new(1, -INNER * 2, 0, 4),
            Position         = UDim2.new(0, INNER, 0, TRK_Y),
            BackgroundColor3 = Color3.fromRGB(40, 40, 40),
            ZIndex           = 10,
            Parent           = f,
        })
        ni("UICorner", { CornerRadius = UDim.new(1, 0), Parent = trk })
        local p0   = (default - minV) / (maxV - minV)
        local fill = ni("Frame", {
            Size             = UDim2.new(p0, 0, 1, 0),
            BackgroundColor3 = Color3.fromRGB(88, 88, 88),
            ZIndex           = 11,
            Parent           = trk,
        })
        ni("UICorner", { CornerRadius = UDim.new(1, 0), Parent = fill })
        local knob = ni("Frame", {
            Size             = UDim2.new(0, KNB, 0, KNB),
            Position         = UDim2.new(p0, -KNB / 2, 0.5, -KNB / 2),
            BackgroundColor3 = C.white,
            ZIndex           = 12,
            Parent           = trk,
        })
        ni("UICorner", { CornerRadius = UDim.new(1, 0), Parent = knob })

        local cur = default
        liveState[key] = default

        local function snapToIncr(v)
            if incr and incr > 0 then
                v = math.floor((v - minV) / incr + 0.5) * incr + minV
            end
            return math.clamp(v, minV, maxV)
        end
        local function apply(v)
            v = snapToIncr(v); cur = v; liveState[key] = v
            vBox.Text = tostring(v) .. (suffix ~= "" and " " .. suffix or "")
            local p = (v - minV) / (maxV - minV)
            tw(fill, FAST, { Size = UDim2.new(p, 0, 1, 0) })
            tw(knob, FAST, { Position = UDim2.new(p, -KNB / 2, 0.5, -KNB / 2) })
            task.spawn(callback, v)
        end
        liveSetters[key] = apply

        stepMinus.MouseButton1Click:Connect(function()
            tw(stepMinus, TweenInfo.new(0.07), { BackgroundColor3 = Color3.fromRGB(62, 62, 62) })
            task.delay(0.10, function() tw(stepMinus, FAST, { BackgroundColor3 = Color3.fromRGB(48, 48, 48) }) end)
            apply(cur - incr)
        end)
        stepPlus.MouseButton1Click:Connect(function()
            tw(stepPlus, TweenInfo.new(0.07), { BackgroundColor3 = Color3.fromRGB(62, 62, 62) })
            task.delay(0.10, function() tw(stepPlus, FAST, { BackgroundColor3 = Color3.fromRGB(48, 48, 48) }) end)
            apply(cur + incr)
        end)
        for _, sb in ipairs({ stepMinus, stepPlus }) do
            sb.MouseEnter:Connect(function() tw(sb, FAST, { BackgroundColor3 = Color3.fromRGB(48, 48, 48) }) end)
            sb.MouseLeave:Connect(function() tw(sb, FAST, { BackgroundColor3 = C.w12 }) end)
        end
        vBox.FocusLost:Connect(function()
            local raw = vBox.Text:gsub("[^%d%.%-]", "")
            local n   = tonumber(raw)
            if n then apply(n) else vBox.Text = tostring(cur) .. (suffix ~= "" and " " .. suffix or "") end
        end)

        local sliding      = false
        local slideTouchId = nil
        local touchHitH    = isMobile and 32 or 22

        local hitZone = ni("TextButton", {
            Size                   = UDim2.new(1, 0, 0, touchHitH),
            Position               = UDim2.new(0, 0, 0.5, -touchHitH / 2),
            BackgroundTransparency = 1,
            Text                   = "",
            ZIndex                 = 13,
            Parent                 = trk,
        })
        local function fromX(x)
            local rel = math.clamp((x - trk.AbsolutePosition.X) / trk.AbsoluteSize.X, 0, 1)
            apply(minV + rel * (maxV - minV))
        end
        hitZone.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then
                sliding = true
                tw(knob, SPRING, { Size = UDim2.new(0, KNB + 4, 0, KNB + 4), Position = UDim2.new(knob.Position.X.Scale, knob.Position.X.Offset - 2, 0.5, -(KNB + 4) / 2) })
                fromX(UserInputService:GetMouseLocation().X)
            elseif i.UserInputType == Enum.UserInputType.Touch then
                sliding = true; slideTouchId = i
                tw(knob, SPRING, { Size = UDim2.new(0, KNB + 4, 0, KNB + 4) })
                fromX(i.Position.X)
            end
        end)
        hitZone.InputChanged:Connect(function(i)
            if sliding and i.UserInputType == Enum.UserInputType.Touch and i == slideTouchId then
                fromX(i.Position.X)
            end
        end)
        UserInputService.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then
                if sliding then
                    sliding = false
                    tw(knob, SPRING, { Size = UDim2.new(0, KNB, 0, KNB) })
                end
            end
            if i.UserInputType == Enum.UserInputType.Touch and i == slideTouchId then
                sliding = false; slideTouchId = nil
                tw(knob, SPRING, { Size = UDim2.new(0, KNB, 0, KNB) })
            end
        end)
        UserInputService.InputChanged:Connect(function(i)
            if sliding and i.UserInputType == Enum.UserInputType.MouseMovement then fromX(i.Position.X) end
        end)
        updateCanvas()

        local SliderObj = {}
        function SliderObj:Set(v)     apply(v) end
        function SliderObj:GetValue() return cur end
        return SliderObj
    end

    function Tab:CreateDropdown(config)
        local label    = config.Name or "Dropdown"
        local options  = config.Options or {}
        local multi    = config.MultipleOptions or false
        local currOpt  = config.CurrentOption or (multi and {} or (options[1] or ""))
        local callback = config.Callback or function() end
        local key      = name .. "/" .. label
        local BTN_W    = isMobile and 110 or 180
        local BTN_H    = isMobile and 22 or 32
        local ROW_I    = isMobile and 24 or RH_I

        local h = RH_DD
        local trigRow = ni("Frame", {
            Size                   = UDim2.new(1, 0, 0, h),
            Position               = UDim2.new(0, 0, 0, cursor),
            BackgroundTransparency = 1,
            ZIndex                 = 9,
            Parent                 = tabFrame,
        })
        rowList[#rowList + 1] = { frame = trigRow, h = h, y = cursor }
        cursor = cursor + h

        ni("TextLabel", {
            Size                   = UDim2.new(0.5, 0, 1, 0),
            Position               = UDim2.new(0, INNER, 0, 0),
            BackgroundTransparency = 1,
            Text                   = label,
            TextColor3             = C.w50,
            Font                   = Enum.Font.GothamBold,
            TextSize               = TS_SM,
            TextXAlignment         = Enum.TextXAlignment.Left,
            ZIndex                 = 10,
            Parent                 = trigRow,
        })

        local btn = ni("Frame", {
            Size             = UDim2.new(0, BTN_W, 0, BTN_H),
            Position         = UDim2.new(1, -INNER - BTN_W, 0.5, -BTN_H / 2),
            BackgroundColor3 = C.vbox,
            ZIndex           = 10,
            Parent           = trigRow,
        })
        ni("UICorner", { CornerRadius = UDim.new(0, 5), Parent = btn })
        local bStroke = ni("UIStroke", { Color = C.border, Thickness = 1, Parent = btn })

        local function selText()
            if multi then
                return (type(currOpt) == "table" and #currOpt > 0) and table.concat(currOpt, ", ") or "None"
            else
                return type(currOpt) == "table" and (currOpt[1] or "None") or (currOpt or "None")
            end
        end

        local selLabel = ni("TextLabel", {
            Size                   = UDim2.new(1, -22, 1, 0),
            Position               = UDim2.new(0, 6, 0, 0),
            BackgroundTransparency = 1,
            Text                   = selText(),
            TextColor3             = C.white,
            Font                   = Enum.Font.GothamMedium,
            TextSize               = TS_MED,
            TextXAlignment         = Enum.TextXAlignment.Left,
            ZIndex                 = 11,
            Parent                 = btn,
        })
        local arrowH    = ni("Frame", { Size = UDim2.new(0, 18, 1, 0), Position = UDim2.new(1, -19, 0, 0), BackgroundTransparency = 1, ZIndex = 11, Parent = btn })
        local arrowIcon = makeArrow(arrowH, 12)

        local visRows       = math.min(isMobile and 5 or 8, #options)
        local fullPanelH    = DD_TP + #options * ROW_I + (#options - 1) * DD_G + DD_TP
        local visiblePanelH = DD_TP + visRows * ROW_I + (visRows - 1) * DD_G + DD_TP

        local overlayPanel = ni("Frame", {
            Size             = UDim2.new(0, BTN_W, 0, 0),
            BackgroundColor3 = C.ddBg,
            ZIndex           = 210,
            ClipsDescendants = true,
            Visible          = false,
            Parent           = OverlayLayer,
        })
        ni("UICorner", { CornerRadius = UDim.new(0, 6), Parent = overlayPanel })
        ni("UIStroke", { Color = C.border, Thickness = 1, Parent = overlayPanel })

        local scrollInner = ni("ScrollingFrame", {
            Size                 = UDim2.new(1, -4, 1, -DD_TP * 2),
            Position             = UDim2.new(0, 2, 0, DD_TP),
            BackgroundTransparency = 1,
            BorderSizePixel      = 0,
            ZIndex               = 211,
            ScrollBarThickness   = 2,
            ScrollBarImageColor3 = C.scrollC,
            CanvasSize           = UDim2.new(0, 0, 0, #options * ROW_I + (#options - 1) * DD_G),
            ScrollingDirection   = Enum.ScrollingDirection.Y,
            ElasticBehavior      = Enum.ElasticBehavior.WhenScrollable,
            Parent               = overlayPanel,
        })
        ni("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, DD_G), Parent = scrollInner })

        local isOpen = false
        local checks = {}
        liveState[key] = currOpt

        local function isSelected(opt)
            if multi then
                if type(currOpt) ~= "table" then return false end
                for _, v in ipairs(currOpt) do if v == opt then return true end end
                return false
            else
                return (type(currOpt) == "table" and currOpt[1] == opt) or currOpt == opt
            end
        end
        local function refreshMarkers()
            for opt, ch in pairs(checks) do
                local sel = isSelected(opt)
                tw(ch.bar, FAST, { BackgroundTransparency = sel and 0 or 1 })
                ch.lbl.TextColor3 = sel and C.white or C.w50
                ch.lbl.Font       = sel and Enum.Font.GothamBold or Enum.Font.GothamMedium
            end
            selLabel.Text = selText()
        end

        local function repositionPanel()
            local absPos   = btn.AbsolutePosition
            local absSize  = btn.AbsoluteSize
            local screenH  = ScreenGui.AbsoluteSize.Y
            local screenW  = ScreenGui.AbsoluteSize.X

            local panelX = absPos.X + absSize.X - BTN_W
            panelX = math.clamp(panelX, 4, screenW - BTN_W - 4)

            local dropY      = absPos.Y + absSize.Y + 4
            local spaceBelow = screenH - dropY - 8
            local panelH
            if spaceBelow >= visiblePanelH or spaceBelow >= 30 then
                panelH = math.min(visiblePanelH, math.max(spaceBelow, 28))
                overlayPanel.Position = UDim2.new(0, panelX, 0, dropY)
            else
                panelH = math.min(visiblePanelH, math.max(absPos.Y - 8, 28))
                overlayPanel.Position = UDim2.new(0, panelX, 0, absPos.Y - panelH - 4)
            end

            local selIdx = 0
            for i, opt in ipairs(options) do
                if isSelected(opt) then selIdx = i; break end
            end
            if selIdx > 0 then
                local targetY   = (selIdx - 1) * (ROW_I + DD_G)
                local maxScroll = math.max(0, #options * ROW_I + (#options - 1) * DD_G - panelH + DD_TP * 2)
                scrollInner.CanvasPosition = Vector2.new(0, math.clamp(targetY - (panelH / 2 - ROW_I / 2), 0, maxScroll))
            else
                scrollInner.CanvasPosition = Vector2.new(0, 0)
            end

            return panelH
        end

        local function close()
            if not isOpen then return end
            isOpen = false
            tw(overlayPanel, SNAP, { Size = UDim2.new(0, BTN_W, 0, 0) })
            tw(arrowIcon, SNAP, { Rotation = 0 })
            tw(bStroke, FAST, { Color = C.border })
            tw(btn, FAST, { BackgroundColor3 = C.vbox })
            task.delay(0.20, function()
                if not isOpen then overlayPanel.Visible = false end
            end)
            if openOverlay == close then openOverlay = nil end
        end

        liveSetters[key] = function(v)
            currOpt = multi and (type(v) == "table" and v or { v }) or v
            liveState[key] = currOpt
            refreshMarkers()
            task.spawn(callback,
                multi and (type(currOpt) == "table" and currOpt or { currOpt })
                    or { type(currOpt) == "table" and currOpt[1] or currOpt })
        end

        for idx, opt in ipairs(options) do
            local item = ni("TextButton", {
                Size             = UDim2.new(1, 0, 0, ROW_I),
                BackgroundColor3 = C.ddRow,
                AutoButtonColor  = false,
                Text             = "",
                ZIndex           = 212,
                LayoutOrder      = idx,
                Parent           = scrollInner,
            })
            ni("UICorner", { CornerRadius = UDim.new(0, 4), Parent = item })
            local bar = ni("Frame", {
                Size                   = UDim2.new(0, 3, 0.5, 0),
                Position               = UDim2.new(0, 0, 0.25, 0),
                BackgroundColor3       = C.white,
                BackgroundTransparency = isSelected(opt) and 0 or 1,
                ZIndex                 = 213,
                Parent                 = item,
            })
            ni("UICorner", { CornerRadius = UDim.new(1, 0), Parent = bar })
            local lbl = ni("TextLabel", {
                Size                   = UDim2.new(1, -10, 1, 0),
                Position               = UDim2.new(0, 8, 0, 0),
                BackgroundTransparency = 1,
                Text                   = opt,
                TextColor3             = isSelected(opt) and C.white or C.w50,
                Font                   = isSelected(opt) and Enum.Font.GothamBold or Enum.Font.GothamMedium,
                TextSize               = TS_MED,
                TextXAlignment         = Enum.TextXAlignment.Left,
                ZIndex                 = 213,
                Parent                 = item,
            })
            checks[opt] = { bar = bar, lbl = lbl }
            item.MouseEnter:Connect(function() tw(item, FAST, { BackgroundColor3 = C.ddHov }) end)
            item.MouseLeave:Connect(function() tw(item, FAST, { BackgroundColor3 = C.ddRow }) end)
            item.MouseButton1Click:Connect(function()
                if multi then
                    if isSelected(opt) then
                        if type(currOpt) == "table" then
                            for i, v in ipairs(currOpt) do if v == opt then table.remove(currOpt, i); break end end
                        end
                    else
                        if type(currOpt) ~= "table" then currOpt = {} end
                        table.insert(currOpt, opt)
                    end
                    liveState[key] = currOpt
                    refreshMarkers()
                    task.spawn(callback, type(currOpt) == "table" and currOpt or { currOpt })
                else
                    currOpt = opt; liveState[key] = currOpt
                    refreshMarkers(); close()
                    task.spawn(callback, { opt })
                end
            end)
        end

        ni("TextButton", {
            Size                   = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Text                   = "",
            ZIndex                 = 12,
            Parent                 = btn,
        }).MouseButton1Click:Connect(function()
            if isOpen then close(); return end
            if openOverlay then openOverlay() end
            isOpen = true; openOverlay = close
            local panelH = repositionPanel()
            overlayPanel.Visible = true
            overlayPanel.Size    = UDim2.new(0, BTN_W, 0, 0)
            tw(btn, FAST, { BackgroundColor3 = Color3.fromRGB(34, 34, 34) })
            tw(overlayPanel, SNAP, { Size = UDim2.new(0, BTN_W, 0, panelH) })
            tw(arrowIcon, SNAP, { Rotation = 180 })
            tw(bStroke, FAST, { Color = C.w25 })
        end)
        updateCanvas()

        local DDObj = {}
        function DDObj:Set(v)     liveSetters[key](v) end
        function DDObj:GetValue() return currOpt end
        return DDObj
    end

    function Tab:CreateKeybind(config)
        local label       = config.Name or "Keybind"
        local currentKey  = config.CurrentKeybind or "Q"
        local holdToInter = config.HoldToInteract or false
        local callback    = config.Callback or function() end
        local key         = name .. "/" .. label

        local h = RH_KB
        local f = ni("Frame", {
            Size                   = UDim2.new(1, 0, 0, h),
            Position               = UDim2.new(0, 0, 0, cursor),
            BackgroundTransparency = 1,
            ZIndex                 = 9,
            Parent                 = tabFrame,
        })
        rowList[#rowList + 1] = { frame = f, h = h, y = cursor }
        cursor = cursor + h

        ni("TextLabel", {
            Size                   = UDim2.new(1, -(isMobile and 130 or 200), 1, 0),
            Position               = UDim2.new(0, INNER, 0, 0),
            BackgroundTransparency = 1,
            Text                   = label,
            TextColor3             = C.w75,
            Font                   = Enum.Font.GothamMedium,
            TextSize               = TS_MED,
            TextXAlignment         = Enum.TextXAlignment.Left,
            ZIndex                 = 10,
            Parent                 = f,
        })

        local BTN_W = isMobile and 110 or 180
        local BTN_H = isMobile and 22 or 32
        local kbBtn = ni("Frame", {
            Size             = UDim2.new(0, BTN_W, 0, BTN_H),
            Position         = UDim2.new(1, -INNER - BTN_W, 0.5, -BTN_H / 2),
            BackgroundColor3 = C.vbox,
            ZIndex           = 10,
            Parent           = f,
        })
        ni("UICorner", { CornerRadius = UDim.new(0, 5), Parent = kbBtn })
        local kbStroke = ni("UIStroke", { Color = C.border, Thickness = 1, Parent = kbBtn })
        local kbLabel  = ni("TextLabel", {
            Size                   = UDim2.new(1, -8, 1, 0),
            Position               = UDim2.new(0, 6, 0, 0),
            BackgroundTransparency = 1,
            Text                   = currentKey,
            TextColor3             = C.white,
            Font                   = Enum.Font.GothamBold,
            TextSize               = TS_MED,
            TextXAlignment         = Enum.TextXAlignment.Left,
            ZIndex                 = 11,
            Parent                 = kbBtn,
        })

        local activeConns = {}
        local function clearConns()
            for _, c in ipairs(activeConns) do if c then c:Disconnect() end end
            activeConns = {}
        end
        local function isInputActive(input, keyName)
            if keyName == "MouseButton1"           then return input.UserInputType == Enum.UserInputType.MouseButton1
            elseif keyName == "MouseButton2"       then return input.UserInputType == Enum.UserInputType.MouseButton2
            elseif keyName == "MouseButton3"       then return input.UserInputType == Enum.UserInputType.MouseButton3
            elseif keyName == "MouseWheelForward"  then return input.UserInputType == Enum.UserInputType.MouseWheel and input.Position.Z > 0
            elseif keyName == "MouseWheelBackward" then return input.UserInputType == Enum.UserInputType.MouseWheel and input.Position.Z < 0
            else
                local ok, kc = pcall(function() return Enum.KeyCode[keyName] end)
                if ok and kc then
                    if input.KeyCode == kc then return true end
                    local alias = {
                        LeftControl = Enum.KeyCode.LeftMeta, RightControl = Enum.KeyCode.RightMeta,
                        LeftMeta    = Enum.KeyCode.LeftControl, RightMeta = Enum.KeyCode.RightControl,
                    }
                    if alias[keyName] and input.KeyCode == alias[keyName] then return true end
                end
            end
            return false
        end
        local function applyKeybind(newKey)
            currentKey = newKey; kbLabel.Text = newKey; kbLabel.TextColor3 = C.white
            liveState[key] = newKey; clearConns()
            if holdToInter then
                table.insert(activeConns, UserInputService.InputBegan:Connect(function(i, gp)
                    if gp then return end
                    if isInputActive(i, newKey) then callback(true) end
                end))
                table.insert(activeConns, UserInputService.InputEnded:Connect(function(i)
                    if isInputActive(i, newKey) then callback(false) end
                end))
            else
                table.insert(activeConns, UserInputService.InputBegan:Connect(function(i, gp)
                    if gp then return end
                    if isInputActive(i, newKey) then callback(false) end
                end))
            end
        end
        liveSetters[key] = applyKeybind

        local listening = false; local listenConn = nil
        local function stopListening(cancelled)
            if not listening then return end
            listening = false
            if listenConn then listenConn:Disconnect(); listenConn = nil end
            tw(kbStroke, FAST, { Color = C.border })
            tw(kbBtn, FAST, { BackgroundColor3 = C.vbox })
            if cancelled then kbLabel.Text = currentKey; kbLabel.TextColor3 = C.white end
            if openOverlay == stopListening then openOverlay = nil end
        end
        local function cancelFromOutside() stopListening(true) end

        ni("TextButton", {
            Size                   = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Text                   = "",
            ZIndex                 = 12,
            Parent                 = kbBtn,
        }).MouseButton1Click:Connect(function()
            if listening then stopListening(true); return end
            if openOverlay then openOverlay() end
            listening = true; openOverlay = cancelFromOutside
            kbLabel.Text = "..."; kbLabel.TextColor3 = C.listen
            tw(kbStroke, FAST, { Color = C.listen })
            tw(kbBtn, FAST, { BackgroundColor3 = Color3.fromRGB(30, 26, 16) })
            task.wait()
            listenConn = UserInputService.InputBegan:Connect(function(i, gp)
                if gp then return end
                local newKey
                if i.UserInputType == Enum.UserInputType.MouseButton1      then newKey = "MouseButton1"
                elseif i.UserInputType == Enum.UserInputType.MouseButton2  then newKey = "MouseButton2"
                elseif i.UserInputType == Enum.UserInputType.MouseButton3  then newKey = "MouseButton3"
                elseif i.UserInputType == Enum.UserInputType.MouseWheel    then
                    newKey = i.Position.Z > 0 and "MouseWheelForward" or "MouseWheelBackward"
                elseif i.KeyCode ~= Enum.KeyCode.Unknown then newKey = i.KeyCode.Name end
                if newKey then
                    tw(kbBtn, TweenInfo.new(0.08), { BackgroundColor3 = Color3.fromRGB(20, 50, 20) })
                    task.delay(0.18, function() tw(kbBtn, MED, { BackgroundColor3 = C.vbox }) end)
                    stopListening(false)
                    applyKeybind(newKey)
                end
            end)
        end)

        applyKeybind(currentKey)
        updateCanvas()

        local KbObj = {}
        function KbObj:Set(newKey) applyKeybind(newKey) end
        function KbObj:GetKey()    return currentKey end
        return KbObj
    end

    if not currentTab then switchTab(name) end
    return setmetatable(Tab, Tab)
end

local savedConfigs    = {}
local selectedCfgName = nil
local CFG_FILE        = "LuaCore_configs.json"

local function jsonEncode(val, indent)
    indent = indent or ""
    local t = type(val)
    if t == "nil"     then return "null"
    elseif t == "boolean" then return tostring(val)
    elseif t == "number"  then
        if val ~= val then return "null" end
        if val == math.huge or val == -math.huge then return "null" end
        return tostring(val)
    elseif t == "string" then
        return '"' .. val:gsub('\\','\\\\'):gsub('"','\\"'):gsub('\n','\\n'):gsub('\r','\\r') .. '"'
    elseif t == "table" then
        local isArr = #val > 0
        if isArr then
            local parts = {}
            for _, v in ipairs(val) do parts[#parts+1] = jsonEncode(v) end
            return "[" .. table.concat(parts, ",") .. "]"
        else
            local parts = {}
            for k, v in pairs(val) do
                parts[#parts+1] = '"' .. tostring(k):gsub('"','\\"') .. '":' .. jsonEncode(v)
            end
            return "{" .. table.concat(parts, ",") .. "}"
        end
    end
    return "null"
end

local function jsonDecode(s)
    s = s:match("^%s*(.-)%s*$")
    if s == "null"  then return nil
    elseif s == "true"  then return true
    elseif s == "false" then return false
    end
    local num = tonumber(s)
    if num then return num end
    if s:sub(1,1) == '"' then
        return s:sub(2,-2):gsub('\\"','"'):gsub('\\n','\n'):gsub('\\\\','\\')
    end
    if s:sub(1,1) == "[" then
        local arr = {}
        local inner = s:sub(2,-2):match("^%s*(.-)%s*$")
        if inner == "" then return arr end
        local depth, start = 0, 1
        for i = 1, #inner do
            local c = inner:sub(i,i)
            if c == "[" or c == "{" then depth = depth + 1
            elseif c == "]" or c == "}" then depth = depth - 1
            elseif c == "," and depth == 0 then
                arr[#arr+1] = jsonDecode(inner:sub(start, i-1):match("^%s*(.-)%s*$"))
                start = i + 1
            end
        end
        arr[#arr+1] = jsonDecode(inner:sub(start):match("^%s*(.-)%s*$"))
        return arr
    end
    if s:sub(1,1) == "{" then
        local obj = {}
        local inner = s:sub(2,-2):match("^%s*(.-)%s*$")
        if inner == "" then return obj end
        local depth, start, inStr, escape = 0, 1, false, false
        for i = 1, #inner do
            local c = inner:sub(i,i)
            if escape then escape = false
            elseif c == "\\" and inStr then escape = true
            elseif c == '"' then inStr = not inStr
            elseif not inStr then
                if c == "{" or c == "[" then depth = depth + 1
                elseif c == "}" or c == "]" then depth = depth - 1
                elseif c == "," and depth == 0 then
                    local pair = inner:sub(start, i-1):match("^%s*(.-)%s*$")
                    local k, v = pair:match('^"(.-)":(.*)')
                    if k and v then
                        obj[k:gsub('\\"','"')] = jsonDecode(v:match("^%s*(.-)%s*$"))
                    end
                    start = i + 1
                end
            end
        end
        local pair = inner:sub(start):match("^%s*(.-)%s*$")
        local k, v = pair:match('^"(.-)":(.*)')
        if k and v then obj[k:gsub('\\"','"')] = jsonDecode(v:match("^%s*(.-)%s*$")) end
        return obj
    end
    return nil
end

local function serializeValue(v)
    local t = type(v)
    if t == "boolean" or t == "number" or t == "string" then return v end
    return nil
end

local function persistSave()
    if not (pcall(function() return writefile end) and writefile) then return end
    local out = {}
    for _, cfg in ipairs(savedConfigs) do
        local safeData = {}
        for k, v in pairs(cfg.data) do
            local sv = serializeValue(v)
            if sv ~= nil then safeData[k] = sv end
        end
        out[#out+1] = { name = cfg.name, data = safeData }
    end
    local ok, err = pcall(writefile, CFG_FILE, jsonEncode(out))
    if not ok then warn("LuaCore: failed to write config file:", err) end
end

local function persistLoad()
    if not (pcall(function() return readfile end) and readfile) then return end
    if not (pcall(function() return isfile end) and isfile and isfile(CFG_FILE)) then return end
    local ok, raw = pcall(readfile, CFG_FILE)
    if not ok or not raw or raw == "" then return end
    local ok2, decoded = pcall(jsonDecode, raw)
    if not ok2 or type(decoded) ~= "table" then return end
    savedConfigs = {}
    for _, entry in ipairs(decoded) do
        if type(entry) == "table" and type(entry.name) == "string" and type(entry.data) == "table" then
            table.insert(savedConfigs, { name = entry.name, data = entry.data })
        end
    end
    if #savedConfigs > 0 then selectedCfgName = savedConfigs[1].name end
end

local cfgTabCanvas = Instance.new("CanvasGroup")
cfgTabCanvas.Size                   = UDim2.new(1, 0, 0, 0)
cfgTabCanvas.BackgroundTransparency = 1
cfgTabCanvas.GroupTransparency      = 1
cfgTabCanvas.BorderSizePixel        = 0
cfgTabCanvas.ZIndex                 = 7
cfgTabCanvas.Visible                = false
cfgTabCanvas.Parent                 = ContentInner

local cfgTabFrame = ni("Frame", {
    Size                   = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    ZIndex                 = 7,
    Parent                 = cfgTabCanvas,
})
tabFrames["Config"] = cfgTabCanvas

local cfgTabBtn = ni("TextButton", {
    Name                   = "Config",
    Size                   = UDim2.new(1, 0, 0, isMobile and 28 or 44),
    BackgroundColor3       = C.panel,
    BackgroundTransparency = 1,
    Text                   = "",
    AutoButtonColor        = false,
    ZIndex                 = 7,
    LayoutOrder            = 99,
    Parent                 = SideList,
})
ni("UICorner", { CornerRadius = UDim.new(0, 6), Parent = cfgTabBtn })
ni("Frame", {
    Name                   = "Accent",
    Size                   = UDim2.new(0, 3, 0.5, 0),
    Position               = UDim2.new(0, 0, 0.25, 0),
    BackgroundColor3       = C.white,
    BackgroundTransparency = 1,
    ZIndex                 = 8,
    Parent                 = cfgTabBtn,
})
ni("UICorner", { CornerRadius = UDim.new(1, 0), Parent = cfgTabBtn:FindFirstChild("Accent") })
if not isMobile then
    ni("ImageLabel", {
        Name                   = "TabIcon",
        Size                   = UDim2.new(0, 16, 0, 16),
        Position               = UDim2.new(0, 10, 0.5, -8),
        BackgroundTransparency = 1,
        Image                  = "rbxassetid://7734053870",
        ImageColor3            = C.w50,
        ZIndex                 = 8,
        Parent                 = cfgTabBtn,
    })
end
local lblX = isMobile and 7 or 32
ni("TextLabel", {
    Name                   = "TabLabel",
    Size                   = UDim2.new(1, -lblX - 3, 1, 0),
    Position               = UDim2.new(0, lblX, 0, 0),
    BackgroundTransparency = 1,
    Text                   = "Config",
    TextColor3             = C.w75,
    Font                   = Enum.Font.GothamMedium,
    TextSize               = TS_MED,
    TextXAlignment         = Enum.TextXAlignment.Left,
    ZIndex                 = 8,
    Parent                 = cfgTabBtn,
})
tabBtns["Config"] = cfgTabBtn
cfgTabBtn.MouseEnter:Connect(function()
    if currentTab ~= "Config" then tw(cfgTabBtn, FAST, { BackgroundTransparency = 0.88 }) end
end)
cfgTabBtn.MouseLeave:Connect(function()
    if currentTab ~= "Config" then tw(cfgTabBtn, FAST, { BackgroundTransparency = 1 }) end
end)
cfgTabBtn.MouseButton1Click:Connect(function() switchTab("Config") end)

ni("TextLabel", {
    Size                   = UDim2.new(1, 0, 0, isMobile and 22 or 34),
    BackgroundTransparency = 1,
    Text                   = "Config",
    TextColor3             = C.white,
    Font                   = Enum.Font.GothamBold,
    TextSize               = isMobile and 13 or 21,
    TextXAlignment         = Enum.TextXAlignment.Left,
    ZIndex                 = 8,
    Parent                 = cfgTabFrame,
})

local saveSecY = isMobile and 26 or 42
local inputH   = isMobile and 22 or 30
local inputRowY = isMobile and 32 or 44
local saveBtnW  = isMobile and 42 or 56

local saveSec = ni("Frame", {
    Size             = UDim2.new(1, 0, 0, inputRowY + inputH + 4 + 14 + 4),
    Position         = UDim2.new(0, 0, 0, saveSecY),
    BackgroundColor3 = C.card,
    ZIndex           = 8,
    Parent           = cfgTabFrame,
})
ni("UICorner", { CornerRadius = UDim.new(0, isMobile and 7 or 10), Parent = saveSec })
ni("UIStroke", { Color = C.border, Thickness = 1, Parent = saveSec })
ni("TextLabel", {
    Size                   = UDim2.new(1, -INNER * 2, 0, isMobile and 26 or 32),
    Position               = UDim2.new(0, INNER, 0, 0),
    BackgroundTransparency = 1,
    Text                   = "SAVE CONFIG",
    TextColor3             = C.w50,
    Font                   = Enum.Font.GothamBold,
    TextSize               = TS_SM,
    TextXAlignment         = Enum.TextXAlignment.Left,
    ZIndex                 = 9,
    Parent                 = saveSec,
})
ni("Frame", {
    Size             = UDim2.new(1, -INNER * 2, 0, 1),
    Position         = UDim2.new(0, INNER, 0, isMobile and 26 or 32),
    BackgroundColor3 = C.border,
    ZIndex           = 9,
    Parent           = saveSec,
})
local nameWrap = ni("Frame", {
    Size             = UDim2.new(1, -INNER * 2 - saveBtnW - 6, 0, inputH),
    Position         = UDim2.new(0, INNER, 0, inputRowY),
    BackgroundColor3 = C.vbox,
    ZIndex           = 9,
    Parent           = saveSec,
})
ni("UICorner", { CornerRadius = UDim.new(0, 5), Parent = nameWrap })
local nameStroke = ni("UIStroke", { Color = C.border, Thickness = 1, Parent = nameWrap })
local nameInput  = ni("TextBox", {
    Size                   = UDim2.new(1, -10, 1, 0),
    Position               = UDim2.new(0, 7, 0, 0),
    BackgroundTransparency = 1,
    PlaceholderText        = "Config name...",
    PlaceholderColor3      = C.w25,
    Text                   = "",
    TextColor3             = C.white,
    Font                   = Enum.Font.GothamMedium,
    TextSize               = TS_MED,
    ClearTextOnFocus       = false,
    TextXAlignment         = Enum.TextXAlignment.Left,
    ZIndex                 = 10,
    Parent                 = nameWrap,
})
local saveBtn = ni("TextButton", {
    Size             = UDim2.new(0, saveBtnW, 0, inputH),
    Position         = UDim2.new(1, -INNER - saveBtnW, 0, inputRowY),
    BackgroundColor3 = C.w12,
    AutoButtonColor  = false,
    Text             = "SAVE",
    TextColor3       = C.white,
    Font             = Enum.Font.GothamBold,
    TextSize         = TS_SM,
    ZIndex           = 9,
    Parent           = saveSec,
})
ni("UICorner", { CornerRadius = UDim.new(0, 5), Parent = saveBtn })
ni("UIStroke", { Color = C.border, Thickness = 1, Parent = saveBtn })
local saveStatus = ni("TextLabel", {
    Size                   = UDim2.new(1, -INNER * 2, 0, 14),
    Position               = UDim2.new(0, INNER, 0, inputRowY + inputH + 4),
    BackgroundTransparency = 1,
    Text                   = "",
    TextColor3             = C.gtext,
    Font                   = Enum.Font.GothamMedium,
    TextSize               = TS_SM,
    TextXAlignment         = Enum.TextXAlignment.Left,
    ZIndex                 = 9,
    Parent                 = saveSec,
})

local saveSecH  = inputRowY + inputH + 4 + 14 + 4
local loadSecY  = saveSecY + saveSecH + 6
local listStartY = isMobile and 30 or 38
local actionRowH = isMobile and 26 or 32

local loadSec = ni("Frame", {
    Size             = UDim2.new(1, 0, 0, 0),
    Position         = UDim2.new(0, 0, 0, loadSecY),
    BackgroundColor3 = C.card,
    ZIndex           = 8,
    ClipsDescendants = false,
    Parent           = cfgTabFrame,
})
ni("UICorner", { CornerRadius = UDim.new(0, isMobile and 7 or 10), Parent = loadSec })
ni("UIStroke", { Color = C.border, Thickness = 1, Parent = loadSec })
ni("TextLabel", {
    Size                   = UDim2.new(1, -INNER * 2, 0, isMobile and 26 or 32),
    Position               = UDim2.new(0, INNER, 0, 0),
    BackgroundTransparency = 1,
    Text                   = "SAVED CONFIGS",
    TextColor3             = C.w50,
    Font                   = Enum.Font.GothamBold,
    TextSize               = TS_SM,
    TextXAlignment         = Enum.TextXAlignment.Left,
    ZIndex                 = 9,
    Parent                 = loadSec,
})
ni("Frame", {
    Size             = UDim2.new(1, -INNER * 2, 0, 1),
    Position         = UDim2.new(0, INNER, 0, isMobile and 26 or 32),
    BackgroundColor3 = C.border,
    ZIndex           = 9,
    Parent           = loadSec,
})

local cfgListContainer = ni("Frame", {
    Size                   = UDim2.new(1, -INNER * 2, 0, 0),
    Position               = UDim2.new(0, INNER, 0, listStartY),
    BackgroundTransparency = 1,
    ZIndex                 = 9,
    Parent                 = loadSec,
})
ni("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 3), Parent = cfgListContainer })

local emptyLabel = ni("TextLabel", {
    Size                   = UDim2.new(1, 0, 0, 36),
    BackgroundTransparency = 1,
    Text                   = "No configs saved yet.",
    TextColor3             = C.w25,
    Font                   = Enum.Font.GothamMedium,
    TextSize               = TS_SM,
    TextXAlignment         = Enum.TextXAlignment.Center,
    TextYAlignment         = Enum.TextYAlignment.Center,
    ZIndex                 = 10,
    Parent                 = cfgListContainer,
})

local actionRow = ni("Frame", {
    Size                   = UDim2.new(1, -INNER * 2, 0, actionRowH),
    Position               = UDim2.new(0, INNER, 0, 0),
    BackgroundTransparency = 1,
    ZIndex                 = 9,
    Parent                 = loadSec,
})
local loadBtn = ni("TextButton", {
    Size             = UDim2.new(0.5, -3, 1, 0),
    BackgroundColor3 = C.w12,
    AutoButtonColor  = false,
    Text             = "LOAD",
    TextColor3       = C.white,
    Font             = Enum.Font.GothamBold,
    TextSize         = TS_SM,
    ZIndex           = 10,
    Parent           = actionRow,
})
ni("UICorner", { CornerRadius = UDim.new(0, 5), Parent = loadBtn })
ni("UIStroke", { Color = C.border, Thickness = 1, Parent = loadBtn })
local deleteBtn = ni("TextButton", {
    Size             = UDim2.new(0.5, -3, 1, 0),
    Position         = UDim2.new(0.5, 3, 0, 0),
    BackgroundColor3 = C.w12,
    AutoButtonColor  = false,
    Text             = "DELETE",
    TextColor3       = C.rtext,
    Font             = Enum.Font.GothamBold,
    TextSize         = TS_SM,
    ZIndex           = 10,
    Parent           = actionRow,
})
ni("UICorner", { CornerRadius = UDim.new(0, 5), Parent = deleteBtn })
ni("UIStroke", { Color = C.border, Thickness = 1, Parent = deleteBtn })

local loadStatus = ni("TextLabel", {
    Size                   = UDim2.new(1, -INNER * 2, 0, 14),
    Position               = UDim2.new(0, INNER, 0, 0),
    BackgroundTransparency = 1,
    Text                   = "",
    TextColor3             = C.gtext,
    Font                   = Enum.Font.GothamMedium,
    TextSize               = TS_SM,
    TextXAlignment         = Enum.TextXAlignment.Left,
    ZIndex                 = 9,
    Visible                = false,
    Parent                 = loadSec,
})

local function rebuildCfgUI()
    for _, ch in ipairs(cfgListContainer:GetChildren()) do
        if ch:IsA("TextButton") or (ch:IsA("Frame") and ch.Name == "CfgRow") then ch:Destroy() end
    end
    local itemH      = isMobile and 28 or 34
    local gap        = 3
    local totalItems = #savedConfigs
    if totalItems == 0 then
        emptyLabel.Visible    = true
        cfgListContainer.Size = UDim2.new(1, -INNER * 2, 0, 36)
        actionRow.Position    = UDim2.new(0, INNER, 0, listStartY + 36 + 6)
        loadSec.Size          = UDim2.new(1, 0, 0, listStartY + 36 + 6 + actionRowH + 8)
        loadStatus.Visible    = false
    else
        emptyLabel.Visible = false
        local listH = totalItems * itemH + (totalItems - 1) * gap
        for i, cfg in ipairs(savedConfigs) do
            local isSel = cfg.name == selectedCfgName
            local row   = ni("Frame", {
                Name             = "CfgRow",
                Size             = UDim2.new(1, 0, 0, itemH),
                BackgroundColor3 = isSel and Color3.fromRGB(34, 34, 34) or C.ddRow,
                ZIndex           = 10,
                LayoutOrder      = i,
                Parent           = cfgListContainer,
            })
            ni("UICorner", { CornerRadius = UDim.new(0, 5), Parent = row })
            ni("UIStroke", { Color = isSel and C.w25 or C.border, Thickness = 1, Parent = row })
            if isSel then
                local bar = ni("Frame", { Size = UDim2.new(0, 3, 0.5, 0), Position = UDim2.new(0, 0, 0.25, 0), BackgroundColor3 = C.white, ZIndex = 11, Parent = row })
                ni("UICorner", { CornerRadius = UDim.new(1, 0), Parent = bar })
            end
            ni("TextLabel", {
                Size                   = UDim2.new(1, -14, 1, 0),
                Position               = UDim2.new(0, 9, 0, 0),
                BackgroundTransparency = 1,
                Text                   = cfg.name,
                TextColor3             = isSel and C.white or C.w75,
                Font                   = isSel and Enum.Font.GothamBold or Enum.Font.GothamMedium,
                TextSize               = TS_MED,
                TextXAlignment         = Enum.TextXAlignment.Left,
                ZIndex                 = 11,
                Parent                 = row,
            })
            local hit = ni("TextButton", { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "", ZIndex = 12, Parent = row })
            hit.MouseButton1Click:Connect(function() selectedCfgName = cfg.name; rebuildCfgUI() end)
            row.MouseEnter:Connect(function() if not isSel then tw(row, FAST, { BackgroundColor3 = C.ddHov }) end end)
            row.MouseLeave:Connect(function() if not isSel then tw(row, FAST, { BackgroundColor3 = C.ddRow }) end end)
        end
        cfgListContainer.Size = UDim2.new(1, -INNER * 2, 0, listH)
        actionRow.Position    = UDim2.new(0, INNER, 0, listStartY + listH + 6)
        loadSec.Size          = UDim2.new(1, 0, 0, listStartY + listH + 6 + actionRowH + 18)
        loadStatus.Position   = UDim2.new(0, INNER, 0, listStartY + listH + 6 + actionRowH + 3)
        loadStatus.Visible    = true
    end
    local totalH = loadSecY + loadSec.Size.Y.Offset + 10
    TAB_CANVAS["Config"] = totalH
    cfgTabFrame.Size     = UDim2.new(1, 0, 0, totalH)
    cfgTabCanvas.Size    = UDim2.new(1, 0, 0, totalH)
    if currentTab == "Config" then ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, totalH) end
end

local function flashBtn(btn, col)
    local origBg = btn.BackgroundColor3
    tw(btn, FAST, { BackgroundColor3 = col })
    task.delay(0.6, function() tw(btn, MED, { BackgroundColor3 = origBg }) end)
end

saveBtn.MouseButton1Click:Connect(function()
    local cfgName = (nameInput.Text):match("^%s*(.-)%s*$")
    if cfgName == "" then
        tw(nameStroke, FAST, { Color = Color3.fromRGB(200, 60, 60) })
        saveStatus.Text = "⚠ Enter a name."; saveStatus.TextColor3 = C.rtext
        task.delay(1.5, function() tw(nameStroke, MED, { Color = C.border }); saveStatus.Text = "" end)
        return
    end
    local snap = {}
    for k, v in pairs(liveState) do snap[k] = v end
    local found = false
    for _, c in ipairs(savedConfigs) do if c.name == cfgName then c.data = snap; found = true; break end end
    if not found then table.insert(savedConfigs, { name = cfgName, data = snap }) end
    selectedCfgName = cfgName; nameInput.Text = ""
    saveStatus.Text = '✓ Saved "' .. cfgName .. '"'; saveStatus.TextColor3 = C.gtext
    task.delay(2, function() saveStatus.Text = "" end)
    flashBtn(saveBtn, C.green)
    persistSave()
    rebuildCfgUI()
end)

loadBtn.MouseButton1Click:Connect(function()
    if not selectedCfgName then
        loadStatus.Text = "⚠ Select a config."; loadStatus.TextColor3 = C.rtext
        task.delay(1.5, function() loadStatus.Text = "" end); return
    end
    for _, c in ipairs(savedConfigs) do
        if c.name == selectedCfgName then
            for k, v in pairs(c.data) do if liveSetters[k] then liveSetters[k](v) end end
            loadStatus.Text = '✓ Loaded "' .. selectedCfgName .. '"'; loadStatus.TextColor3 = C.gtext
            task.delay(2, function() loadStatus.Text = "" end)
            flashBtn(loadBtn, C.blue); break
        end
    end
end)

deleteBtn.MouseButton1Click:Connect(function()
    if not selectedCfgName then
        loadStatus.Text = "⚠ Select one first."; loadStatus.TextColor3 = C.rtext
        task.delay(1.5, function() loadStatus.Text = "" end); return
    end
    local deleted = selectedCfgName
    for i, c in ipairs(savedConfigs) do if c.name == selectedCfgName then table.remove(savedConfigs, i); break end end
    selectedCfgName = #savedConfigs > 0 and savedConfigs[1].name or nil
    loadStatus.Text = 'Deleted "' .. deleted .. '"'; loadStatus.TextColor3 = C.rtext
    task.delay(2, function() loadStatus.Text = "" end)
    flashBtn(deleteBtn, C.red)
    persistSave()
    rebuildCfgUI()
end)

for _, b in ipairs({ saveBtn, loadBtn, deleteBtn }) do
    b.MouseEnter:Connect(function() tw(b, FAST, { BackgroundColor3 = Color3.fromRGB(42, 42, 42) }) end)
    b.MouseLeave:Connect(function() tw(b, FAST, { BackgroundColor3 = C.w12 }) end)
end

TAB_CANVAS["Config"] = loadSecY + 140
cfgTabFrame.Size     = UDim2.new(1, 0, 0, loadSecY + 140)
cfgTabCanvas.Size    = UDim2.new(1, 0, 0, loadSecY + 140)
persistLoad()
rebuildCfgUI()

local MobGlow = ni("Frame", {
    Size                   = UDim2.new(0, 52, 0, 52),
    Position               = UDim2.new(1, -66, 0, 14),
    BackgroundColor3       = C.white,
    BackgroundTransparency = 0.84,
    ZIndex                 = 50,
    Visible                = isMobile,
    Parent                 = ScreenGui,
})
ni("UICorner", { CornerRadius = UDim.new(1, 0), Parent = MobGlow })
local MobBtn = ni("TextButton", {
    Size             = UDim2.new(0, 42, 0, 42),
    Position         = UDim2.new(0.5, -21, 0.5, -21),
    BackgroundColor3 = Color3.fromRGB(20, 20, 20),
    AutoButtonColor  = false,
    Text             = "",
    ZIndex           = 51,
    Parent           = MobGlow,
})
ni("UICorner", { CornerRadius = UDim.new(1, 0), Parent = MobBtn })
ni("UIStroke", { Color = Color3.fromRGB(65, 65, 65), Thickness = 1.5, Parent = MobBtn })
ni("ImageLabel", {
    Size                   = UDim2.new(0, 24, 0, 24),
    Position               = UDim2.new(0.5, -12, 0.5, -12),
    BackgroundTransparency = 1,
    Image                  = "rbxassetid://112326774527295",
    ScaleType              = Enum.ScaleType.Fit,
    ZIndex                 = 52,
    Parent                 = MobBtn,
})

local mobDrag, mobMoved, mobDS, mobDP = false, false, Vector3.new(), UDim2.new()
MobBtn.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then
        mobDrag = true; mobMoved = false; mobDS = i.Position; mobDP = MobGlow.Position
    end
end)
MobBtn.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then
        if not mobMoved then
            setVisible(not guiVisible)
            tw(MobGlow, TweenInfo.new(0.08, Enum.EasingStyle.Quart), { BackgroundTransparency = 0.5 })
            task.delay(0.15, function() tw(MobGlow, TweenInfo.new(0.3, Enum.EasingStyle.Quart), { BackgroundTransparency = 0.84 }) end)
        end
        mobDrag = false; mobMoved = false
    end
end)
UserInputService.InputChanged:Connect(function(i)
    if mobDrag and (i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseMovement) then
        local d = i.Position - mobDS
        if not mobMoved and (math.abs(d.X) + math.abs(d.Y)) > 5 then mobMoved = true end
        if mobMoved then MobGlow.Position = UDim2.new(mobDP.X.Scale, mobDP.X.Offset + d.X, mobDP.Y.Scale, mobDP.Y.Offset + d.Y) end
    end
end)

return LuaCore
