-- ╔══════════════════════════════════════════╗
-- ║         Da7muUI - Roblox UI Library      ║
-- ║     Blur · Rounded · Shadow · Glass      ║
-- ╚══════════════════════════════════════════╝

local Da7muUI = {}
Da7muUI.__index = Da7muUI

-- ─── Services ───────────────────────────────
local Players           = game:GetService("Players")
local TweenService      = game:GetService("TweenService")
local UserInputService  = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

-- ─── Internal State ─────────────────────────
local Themes = {}

-- ─── Utility ────────────────────────────────
local function Tween(obj, props, t, style, dir)
    TweenService:Create(obj,
        TweenInfo.new(t or 0.25, style or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out),
        props
    ):Play()
end

local function New(class, props, parent)
    local o = Instance.new(class)
    for k, v in pairs(props or {}) do
        pcall(function() o[k] = v end)
    end
    if parent then o.Parent = parent end
    return o
end

local function Corner(p, r)
    New("UICorner", { CornerRadius = UDim.new(0, r or 10) }, p)
end

local function Stroke(p, color, thickness, trans)
    New("UIStroke", {
        Color        = color or Color3.fromRGB(255,255,255),
        Thickness    = thickness or 1,
        Transparency = trans or 0.75
    }, p)
end

local function Shadow(parent)
    New("ImageLabel", {
        Name               = "_Shadow",
        AnchorPoint        = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Position           = UDim2.new(0.5, 0, 0.5, 8),
        Size               = UDim2.new(1, 46, 1, 46),
        ZIndex             = parent.ZIndex - 1,
        Image              = "rbxassetid://6015897843",
        ImageColor3        = Color3.fromRGB(0,0,0),
        ImageTransparency  = 0.35,
        ScaleType          = Enum.ScaleType.Slice,
        SliceCenter        = Rect.new(49,49,450,450)
    }, parent)
end

local function Draggable(handle, target)
    local drag, sPos, sObjPos = false
    handle.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            drag = true
            sPos = i.Position
            sObjPos = target.Position
        end
    end)
    handle.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if drag and i.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = i.Position - sPos
            target.Position = UDim2.new(
                sObjPos.X.Scale, sObjPos.X.Offset + delta.X,
                sObjPos.Y.Scale, sObjPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- ─── Default Theme ───────────────────────────
local DefaultTheme = {
    Name        = "Default",
    Background  = Color3.fromRGB(14, 14, 18),
    Accent      = Color3.fromRGB(0, 200, 220),
    Dialog      = Color3.fromRGB(20, 20, 27),
    Outline     = Color3.fromRGB(255, 255, 255),
    Text        = Color3.fromRGB(255, 255, 255),
    Placeholder = Color3.fromRGB(140, 140, 160),
    Button      = Color3.fromRGB(0, 200, 220),
    Icon        = Color3.fromRGB(0, 160, 180),
    TabBg       = Color3.fromRGB(18, 18, 24),
}
Themes["Default"] = DefaultTheme

-- ─── Theme Registration ──────────────────────
function Da7muUI:AddTheme(t)
    Themes[t.Name] = t
end

-- ─── CreateWindow ────────────────────────────
function Da7muUI:CreateWindow(cfg)
    local theme  = Themes[cfg.Theme or "Default"] or Themes["Default"]
    local W      = cfg.Size and cfg.Size.X.Offset or 560
    local H      = cfg.Size and cfg.Size.Y.Offset or 400
    local sideW  = cfg.SideBarWidth or 140
    local title  = cfg.Title or "Da7muUI"

    -- ── ScreenGui ──────────────────────────────
    local Gui = New("ScreenGui", {
        Name           = "Da7muUI_" .. title,
        ResetOnSpawn   = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder   = 999,
    })
    pcall(function() Gui.Parent = game:GetService("CoreGui") end)
    if not Gui.Parent then Gui.Parent = LocalPlayer.PlayerGui end

    -- ── Background Blur ────────────────────────
    local blur = New("BlurEffect", { Size = 0 }, game:GetService("Lighting"))
    Tween(blur, { Size = 18 }, 0.5)

    -- ── Main Frame ─────────────────────────────
    local Main = New("Frame", {
        Name                   = "Window",
        AnchorPoint            = Vector2.new(0.5, 0.5),
        Position               = UDim2.new(0.5, 0, 0.5, 0),
        Size                   = UDim2.new(0, W, 0, H),
        BackgroundColor3       = theme.Background,
        BackgroundTransparency = 0.2,   -- glass transparency
        BorderSizePixel        = 0,
        ZIndex                 = 10,
        ClipsDescendants       = true,
    }, Gui)
    Corner(Main, 14)
    Shadow(Main)
    Stroke(Main, theme.Outline, 1, 0.8)

    -- Subtle inner glass highlight
    New("Frame", {
        Size                   = UDim2.new(1,0,1,0),
        BackgroundColor3       = Color3.fromRGB(255,255,255),
        BackgroundTransparency = 0.96,
        BorderSizePixel        = 0,
        ZIndex                 = 10,
    }, Main)

    -- ── Top Bar ────────────────────────────────
    local TopBar = New("Frame", {
        Name                   = "TopBar",
        Size                   = UDim2.new(1, 0, 0, 46),
        BackgroundColor3       = theme.Dialog,
        BackgroundTransparency = 0.1,
        BorderSizePixel        = 0,
        ZIndex                 = 11,
    }, Main)
    Corner(TopBar, 14)
    -- Patch bottom corners
    New("Frame", {
        Position               = UDim2.new(0,0,1,-14),
        Size                   = UDim2.new(1,0,0,14),
        BackgroundColor3       = theme.Dialog,
        BackgroundTransparency = 0.1,
        BorderSizePixel        = 0,
        ZIndex                 = 11,
    }, TopBar)

    -- Icon
    if cfg.Icon and cfg.Icon ~= "" then
        New("ImageLabel", {
            Size                   = UDim2.new(0, cfg.IconSize or 28, 0, cfg.IconSize or 28),
            Position               = UDim2.new(0, 12, 0.5, 0),
            AnchorPoint            = Vector2.new(0, 0.5),
            BackgroundTransparency = 1,
            Image                  = cfg.Icon,
            ZIndex                 = 12,
        }, TopBar)
    end

    local iconOffset = cfg.Icon and ((cfg.IconSize or 28) + 20) or 14

    -- Title
    New("TextLabel", {
        Text               = title,
        Font               = Enum.Font.GothamBold,
        TextSize           = 15,
        TextColor3         = theme.Text,
        BackgroundTransparency = 1,
        Position           = UDim2.new(0, iconOffset, 0, 0),
        Size               = UDim2.new(1, -140, 1, 0),
        TextXAlignment     = Enum.TextXAlignment.Left,
        ZIndex             = 12,
    }, TopBar)

    -- Author
    if cfg.Author then
        New("TextLabel", {
            Text               = cfg.Author,
            Font               = Enum.Font.Gotham,
            TextSize           = 11,
            TextColor3         = theme.Placeholder,
            BackgroundTransparency = 1,
            Position           = UDim2.new(1, -130, 0, 0),
            Size               = UDim2.new(0, 120, 1, 0),
            TextXAlignment     = Enum.TextXAlignment.Right,
            ZIndex             = 12,
        }, TopBar)
    end

    -- Minimise button
    local minimised = false
    local MinBtn = New("TextButton", {
        Text               = "—",
        Font               = Enum.Font.GothamBold,
        TextSize           = 14,
        TextColor3         = theme.Placeholder,
        BackgroundTransparency = 1,
        Position           = UDim2.new(1, -64, 0.5, 0),
        AnchorPoint        = Vector2.new(0, 0.5),
        Size               = UDim2.new(0, 26, 0, 26),
        ZIndex             = 13,
    }, TopBar)

    MinBtn.MouseButton1Click:Connect(function()
        minimised = not minimised
        Tween(Main, { Size = minimised and UDim2.new(0,W,0,46) or UDim2.new(0,W,0,H) }, 0.3)
    end)
    MinBtn.MouseEnter:Connect(function() Tween(MinBtn,{TextColor3=theme.Text},0.1) end)
    MinBtn.MouseLeave:Connect(function() Tween(MinBtn,{TextColor3=theme.Placeholder},0.1) end)

    -- Close button
    local CloseBtn = New("TextButton", {
        Text               = "✕",
        Font               = Enum.Font.GothamBold,
        TextSize           = 13,
        TextColor3         = Color3.fromRGB(255, 75, 75),
        BackgroundTransparency = 1,
        Position           = UDim2.new(1, -36, 0.5, 0),
        AnchorPoint        = Vector2.new(0, 0.5),
        Size               = UDim2.new(0, 26, 0, 26),
        ZIndex             = 13,
    }, TopBar)

    CloseBtn.MouseButton1Click:Connect(function()
        Tween(Main, { BackgroundTransparency = 1 }, 0.3)
        Tween(blur, { Size = 0 }, 0.4)
        task.delay(0.4, function() Gui:Destroy() end)
    end)
    CloseBtn.MouseEnter:Connect(function() Tween(CloseBtn,{TextColor3=Color3.fromRGB(255,120,120)},0.1) end)
    CloseBtn.MouseLeave:Connect(function() Tween(CloseBtn,{TextColor3=Color3.fromRGB(255,75,75)},0.1) end)

    -- Make topbar draggable
    Draggable(TopBar, Main)

    -- ── Sidebar ────────────────────────────────
    local Sidebar = New("Frame", {
        Position               = UDim2.new(0, 0, 0, 46),
        Size                   = UDim2.new(0, sideW, 1, -46),
        BackgroundColor3       = theme.TabBg,
        BackgroundTransparency = 0.2,
        BorderSizePixel        = 0,
        ZIndex                 = 11,
    }, Main)

    New("UIListLayout", {
        FillDirection = Enum.FillDirection.Vertical,
        Padding       = UDim.new(0, 4),
        SortOrder     = Enum.SortOrder.LayoutOrder,
    }, Sidebar)
    New("UIPadding", {
        PaddingTop=UDim.new(0,8), PaddingLeft=UDim.new(0,8),
        PaddingRight=UDim.new(0,8)
    }, Sidebar)

    -- Sidebar/content divider
    New("Frame", {
        Position           = UDim2.new(0, sideW, 0, 46),
        Size               = UDim2.new(0, 1, 1, -46),
        BackgroundColor3   = theme.Outline,
        BackgroundTransparency = 0.8,
        BorderSizePixel    = 0,
        ZIndex             = 12,
    }, Main)

    -- ── Content Area ───────────────────────────
    local ContentArea = New("Frame", {
        Position           = UDim2.new(0, sideW + 1, 0, 46),
        Size               = UDim2.new(1, -(sideW+1), 1, -46),
        BackgroundTransparency = 1,
        BorderSizePixel    = 0,
        ZIndex             = 11,
    }, Main)

    -- ── Animate window in ──────────────────────
    Main.BackgroundTransparency = 1
    Main.Position = UDim2.new(0.5, 0, 0.58, 0)
    Tween(Main, {
        BackgroundTransparency = 0.2,
        Position = UDim2.new(0.5, 0, 0.5, 0)
    }, 0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

    -- ───────────────────────────────────────────
    -- Window Object
    -- ───────────────────────────────────────────
    local WindowObj = {}
    local Tabs      = {}
    local ActiveTab = nil

    -- ── AddTab ─────────────────────────────────
    function WindowObj:AddTab(tabCfg)
        local tabName = tabCfg.Name or "Tab"

        -- Page (scrolling)
        local Page = New("ScrollingFrame", {
            Name                   = "Page_"..tabName,
            Size                   = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            BorderSizePixel        = 0,
            ScrollBarThickness     = 3,
            ScrollBarImageColor3   = theme.Accent,
            Visible                = false,
            ZIndex                 = 12,
            AutomaticCanvasSize    = Enum.AutomaticSize.Y,
            CanvasSize             = UDim2.new(0,0,0,0),
        }, ContentArea)

        New("UIListLayout", {
            FillDirection = Enum.FillDirection.Vertical,
            Padding       = UDim.new(0, 8),
            SortOrder     = Enum.SortOrder.LayoutOrder,
        }, Page)
        New("UIPadding", {
            PaddingTop=UDim.new(0,10), PaddingLeft=UDim.new(0,12),
            PaddingRight=UDim.new(0,12), PaddingBottom=UDim.new(0,10)
        }, Page)

        -- Sidebar button
        local TabBtn = New("TextButton", {
            Text                   = (tabCfg.Icon and tabCfg.Icon.." " or "")..tabName,
            Font                   = Enum.Font.Gotham,
            TextSize               = 13,
            TextColor3             = theme.Placeholder,
            BackgroundColor3       = theme.Accent,
            BackgroundTransparency = 1,
            Size                   = UDim2.new(1, 0, 0, 34),
            TextXAlignment         = Enum.TextXAlignment.Left,
            ZIndex                 = 12,
            LayoutOrder            = #Tabs + 1,
        }, Sidebar)
        Corner(TabBtn, 8)
        New("UIPadding",{PaddingLeft=UDim.new(0,10)},TabBtn)

        -- Left accent bar (hidden when inactive)
        local AccentBar = New("Frame", {
            Size                 = UDim2.new(0,3,0.6,0),
            Position             = UDim2.new(0,0,0.2,0),
            BackgroundColor3     = theme.Accent,
            BackgroundTransparency = 1,
            ZIndex               = 13,
        }, TabBtn)
        Corner(AccentBar, 2)

        local function SelectTab()
            for _, t in pairs(Tabs) do
                t.Page.Visible = false
                Tween(t.Btn,{BackgroundTransparency=1,TextColor3=theme.Placeholder},0.15)
                Tween(t.Bar,{BackgroundTransparency=1},0.15)
            end
            Page.Visible = true
            Tween(TabBtn,{BackgroundTransparency=0.8,TextColor3=theme.Text},0.15)
            Tween(AccentBar,{BackgroundTransparency=0},0.15)
            ActiveTab = tabName
        end

        TabBtn.MouseButton1Click:Connect(SelectTab)
        TabBtn.MouseEnter:Connect(function()
            if ActiveTab ~= tabName then Tween(TabBtn,{BackgroundTransparency=0.9},0.1) end
        end)
        TabBtn.MouseLeave:Connect(function()
            if ActiveTab ~= tabName then Tween(TabBtn,{BackgroundTransparency=1},0.1) end
        end)

        table.insert(Tabs, { Page=Page, Btn=TabBtn, Bar=AccentBar })
        if #Tabs == 1 then SelectTab() end

        -- ────────────────────────────────────────
        local TabObj = {}

        -- ── AddSection ───────────────────────────
        function TabObj:AddSection(sCfg)
            -- Section header label
            if sCfg.Name and sCfg.Name ~= "" then
                New("TextLabel", {
                    Text               = sCfg.Name:upper(),
                    Font               = Enum.Font.GothamBold,
                    TextSize           = 10,
                    TextColor3         = theme.Placeholder,
                    BackgroundTransparency = 1,
                    Size               = UDim2.new(1,0,0,16),
                    TextXAlignment     = Enum.TextXAlignment.Left,
                    ZIndex             = 13,
                }, Page)
            end

            local SFrame = New("Frame", {
                Size                   = UDim2.new(1,0,0,0),
                AutomaticSize          = Enum.AutomaticSize.Y,
                BackgroundColor3       = theme.Dialog,
                BackgroundTransparency = 0.28,
                BorderSizePixel        = 0,
                ZIndex                 = 12,
            }, Page)
            Corner(SFrame, 10)
            Stroke(SFrame, theme.Outline, 1, 0.84)

            New("UIListLayout", {
                FillDirection = Enum.FillDirection.Vertical,
                Padding       = UDim.new(0, 6),
                SortOrder     = Enum.SortOrder.LayoutOrder,
            }, SFrame)
            New("UIPadding", {
                PaddingTop=UDim.new(0,10), PaddingLeft=UDim.new(0,10),
                PaddingRight=UDim.new(0,10), PaddingBottom=UDim.new(0,10)
            }, SFrame)

            local SectionObj = {}

            -- ── AddToggle ──────────────────────────
            function SectionObj:AddToggle(cfg2)
                local state = cfg2.Default or false

                local Row = New("Frame", {
                    Size=UDim2.new(1,0,0,36),
                    BackgroundTransparency=1, ZIndex=14
                }, SFrame)

                New("TextLabel", {
                    Text=cfg2.Name or "Toggle",
                    Font=Enum.Font.Gotham, TextSize=13,
                    TextColor3=theme.Text, BackgroundTransparency=1,
                    Position=UDim2.new(0,0,0,0), Size=UDim2.new(1,-54,0.55,0),
                    TextXAlignment=Enum.TextXAlignment.Left, ZIndex=14
                }, Row)

                if cfg2.Description then
                    New("TextLabel", {
                        Text=cfg2.Description,
                        Font=Enum.Font.Gotham, TextSize=10,
                        TextColor3=theme.Placeholder, BackgroundTransparency=1,
                        Position=UDim2.new(0,0,0.55,0), Size=UDim2.new(1,-54,0.45,0),
                        TextXAlignment=Enum.TextXAlignment.Left, ZIndex=14
                    }, Row)
                end

                local Track = New("Frame", {
                    Position=UDim2.new(1,-46,0.5,0), AnchorPoint=Vector2.new(0,0.5),
                    Size=UDim2.new(0,40,0,20),
                    BackgroundColor3=state and theme.Accent or Color3.fromRGB(55,55,68),
                    BackgroundTransparency=0.15, ZIndex=14
                }, Row)
                Corner(Track,10)

                local Knob = New("Frame", {
                    Position=state and UDim2.new(1,-18,0.5,0) or UDim2.new(0,2,0.5,0),
                    AnchorPoint=Vector2.new(0,0.5),
                    Size=UDim2.new(0,16,0,16),
                    BackgroundColor3=Color3.fromRGB(255,255,255), ZIndex=15
                }, Track)
                Corner(Knob,8)

                New("TextButton", {
                    Text="", BackgroundTransparency=1,
                    Size=UDim2.new(1,0,1,0), ZIndex=16
                }, Track).MouseButton1Click:Connect(function()
                    state = not state
                    Tween(Track,{BackgroundColor3=state and theme.Accent or Color3.fromRGB(55,55,68)},0.2)
                    Tween(Knob,{Position=state and UDim2.new(1,-18,0.5,0) or UDim2.new(0,2,0.5,0)},0.2)
                    if cfg2.Callback then cfg2.Callback(state) end
                end)

                local obj = {}
                function obj:Set(v)
                    state=v
                    Tween(Track,{BackgroundColor3=v and theme.Accent or Color3.fromRGB(55,55,68)},0.2)
                    Tween(Knob,{Position=v and UDim2.new(1,-18,0.5,0) or UDim2.new(0,2,0.5,0)},0.2)
                    if cfg2.Callback then cfg2.Callback(v) end
                end
                function obj:Get() return state end
                return obj
            end

            -- ── AddButton ──────────────────────────
            function SectionObj:AddButton(cfg2)
                local Btn = New("TextButton", {
                    Text=cfg2.Name or "Button",
                    Font=Enum.Font.GothamBold, TextSize=13,
                    TextColor3=Color3.fromRGB(10,10,14),
                    BackgroundColor3=theme.Button,
                    BackgroundTransparency=0.05,
                    Size=UDim2.new(1,0,0,34), ZIndex=14
                }, SFrame)
                Corner(Btn,8)

                Btn.MouseButton1Click:Connect(function()
                    Tween(Btn,{BackgroundTransparency=0.45},0.08)
                    task.delay(0.12,function() Tween(Btn,{BackgroundTransparency=0.05},0.15) end)
                    if cfg2.Callback then cfg2.Callback() end
                end)
                Btn.MouseEnter:Connect(function() Tween(Btn,{BackgroundTransparency=0.3},0.1) end)
                Btn.MouseLeave:Connect(function() Tween(Btn,{BackgroundTransparency=0.05},0.1) end)

                local obj = {}
                function obj:SetText(t) Btn.Text=t end
                return obj
            end

            -- ── AddSlider ──────────────────────────
            function SectionObj:AddSlider(cfg2)
                local min  = cfg2.Min or 0
                local max  = cfg2.Max or 100
                local step = cfg2.Step or 1
                local val  = math.clamp(cfg2.Default or min, min, max)

                local Row = New("Frame", {
                    Size=UDim2.new(1,0,0,52),
                    BackgroundTransparency=1, ZIndex=14
                }, SFrame)

                New("TextLabel", {
                    Text=cfg2.Name or "Slider",
                    Font=Enum.Font.Gotham, TextSize=13,
                    TextColor3=theme.Text, BackgroundTransparency=1,
                    Position=UDim2.new(0,0,0,0), Size=UDim2.new(0.7,0,0,18),
                    TextXAlignment=Enum.TextXAlignment.Left, ZIndex=14
                }, Row)

                local ValLbl = New("TextLabel", {
                    Text=tostring(val),
                    Font=Enum.Font.GothamBold, TextSize=13,
                    TextColor3=theme.Accent, BackgroundTransparency=1,
                    Position=UDim2.new(0.7,0,0,0), Size=UDim2.new(0.3,0,0,18),
                    TextXAlignment=Enum.TextXAlignment.Right, ZIndex=14
                }, Row)

                local Track = New("Frame", {
                    Position=UDim2.new(0,0,0,26), Size=UDim2.new(1,0,0,8),
                    BackgroundColor3=Color3.fromRGB(45,45,58),
                    BackgroundTransparency=0.2, ZIndex=14
                }, Row)
                Corner(Track,4)

                local pct0 = (val-min)/(max-min)

                local Fill = New("Frame", {
                    Size=UDim2.new(pct0,0,1,0),
                    BackgroundColor3=theme.Accent,
                    BackgroundTransparency=0.15, ZIndex=15
                }, Track)
                Corner(Fill,4)

                local Knob = New("Frame", {
                    Position=UDim2.new(pct0,0,0.5,0),
                    AnchorPoint=Vector2.new(0.5,0.5),
                    Size=UDim2.new(0,14,0,14),
                    BackgroundColor3=Color3.fromRGB(255,255,255), ZIndex=16
                }, Track)
                Corner(Knob,7)

                local sliding = false
                local function Update(input)
                    local rx = math.clamp((input.Position.X - Track.AbsolutePosition.X)/Track.AbsoluteSize.X,0,1)
                    val = math.clamp(math.round((min+rx*(max-min))/step)*step, min, max)
                    local p = (val-min)/(max-min)
                    Fill.Size = UDim2.new(p,0,1,0)
                    Knob.Position = UDim2.new(p,0,0.5,0)
                    ValLbl.Text = tostring(val)
                    if cfg2.Callback then cfg2.Callback(val) end
                end

                Track.InputBegan:Connect(function(i)
                    if i.UserInputType==Enum.UserInputType.MouseButton1 then
                        sliding=true; Update(i)
                    end
                end)
                UserInputService.InputEnded:Connect(function(i)
                    if i.UserInputType==Enum.UserInputType.MouseButton1 then sliding=false end
                end)
                UserInputService.InputChanged:Connect(function(i)
                    if sliding and i.UserInputType==Enum.UserInputType.MouseMovement then Update(i) end
                end)

                local obj={}
                function obj:Set(v)
                    val=math.clamp(math.round(v/step)*step,min,max)
                    local p=(val-min)/(max-min)
                    Fill.Size=UDim2.new(p,0,1,0)
                    Knob.Position=UDim2.new(p,0,0.5,0)
                    ValLbl.Text=tostring(val)
                end
                function obj:Get() return val end
                return obj
            end

            -- ── AddTextBox ─────────────────────────
            function SectionObj:AddTextBox(cfg2)
                New("TextLabel", {
                    Text=cfg2.Name or "Input",
                    Font=Enum.Font.Gotham, TextSize=11,
                    TextColor3=theme.Placeholder, BackgroundTransparency=1,
                    Size=UDim2.new(1,0,0,16),
                    TextXAlignment=Enum.TextXAlignment.Left, ZIndex=14
                }, SFrame)

                local Box = New("TextBox", {
                    PlaceholderText=cfg2.Placeholder or "Type here...",
                    Text=cfg2.Default or "",
                    Font=Enum.Font.Gotham, TextSize=13,
                    TextColor3=theme.Text,
                    PlaceholderColor3=theme.Placeholder,
                    BackgroundColor3=theme.Background,
                    BackgroundTransparency=0.3,
                    Size=UDim2.new(1,0,0,30),
                    ClearTextOnFocus=cfg2.ClearOnFocus~=false,
                    ZIndex=14
                }, SFrame)
                Corner(Box,7)
                Stroke(Box,theme.Accent,1,0.65)
                New("UIPadding",{PaddingLeft=UDim.new(0,8)},Box)

                Box.FocusLost:Connect(function(enter)
                    if cfg2.Callback then cfg2.Callback(Box.Text, enter) end
                end)

                local obj={}
                function obj:Get() return Box.Text end
                function obj:Set(v) Box.Text=v end
                return obj
            end

            -- ── AddDropdown ────────────────────────
            function SectionObj:AddDropdown(cfg2)
                local opts    = cfg2.Options or {}
                local selected = cfg2.Default
                local open    = false

                New("TextLabel", {
                    Text=cfg2.Name or "Dropdown",
                    Font=Enum.Font.Gotham, TextSize=11,
                    TextColor3=theme.Placeholder, BackgroundTransparency=1,
                    Size=UDim2.new(1,0,0,16),
                    TextXAlignment=Enum.TextXAlignment.Left, ZIndex=14
                }, SFrame)

                local HeaderFrame = New("Frame", {
                    Size=UDim2.new(1,0,0,30),
                    BackgroundColor3=theme.Background,
                    BackgroundTransparency=0.3,
                    ZIndex=14
                }, SFrame)
                Corner(HeaderFrame,7)
                Stroke(HeaderFrame,theme.Outline,1,0.78)

                local SelLbl = New("TextLabel", {
                    Text=selected or cfg2.Placeholder or "Select...",
                    Font=Enum.Font.Gotham, TextSize=13,
                    TextColor3=selected and theme.Text or theme.Placeholder,
                    BackgroundTransparency=1,
                    Position=UDim2.new(0,8,0,0), Size=UDim2.new(1,-30,1,0),
                    TextXAlignment=Enum.TextXAlignment.Left, ZIndex=15
                }, HeaderFrame)

                local Arrow = New("TextLabel", {
                    Text="▾", Font=Enum.Font.GothamBold, TextSize=14,
                    TextColor3=theme.Placeholder, BackgroundTransparency=1,
                    Position=UDim2.new(1,-26,0,0), Size=UDim2.new(0,22,1,0),
                    TextXAlignment=Enum.TextXAlignment.Center, ZIndex=15
                }, HeaderFrame)

                local ListFrame = New("Frame", {
                    Size=UDim2.new(1,0,0,math.min(#opts,5)*30+8),
                    BackgroundColor3=theme.Dialog,
                    BackgroundTransparency=0.05,
                    Visible=false, ZIndex=30, ClipsDescendants=true
                }, SFrame)
                Corner(ListFrame,8)
                Stroke(ListFrame,theme.Outline,1,0.78)

                New("UIListLayout",{
                    FillDirection=Enum.FillDirection.Vertical,
                    Padding=UDim.new(0,2), SortOrder=Enum.SortOrder.LayoutOrder
                }, ListFrame)
                New("UIPadding",{
                    PaddingTop=UDim.new(0,4), PaddingLeft=UDim.new(0,4),
                    PaddingRight=UDim.new(0,4)
                }, ListFrame)

                for _, opt in ipairs(opts) do
                    local OBtn = New("TextButton", {
                        Text=opt, Font=Enum.Font.Gotham, TextSize=13,
                        TextColor3=theme.Text, BackgroundTransparency=1,
                        Size=UDim2.new(1,0,0,26),
                        TextXAlignment=Enum.TextXAlignment.Left, ZIndex=31
                    }, ListFrame)
                    Corner(OBtn,6)
                    New("UIPadding",{PaddingLeft=UDim.new(0,8)},OBtn)
                    OBtn.MouseEnter:Connect(function() Tween(OBtn,{BackgroundTransparency=0.78},0.1) end)
                    OBtn.MouseLeave:Connect(function() Tween(OBtn,{BackgroundTransparency=1},0.1) end)
                    OBtn.MouseButton1Click:Connect(function()
                        selected=opt
                        SelLbl.Text=opt
                        SelLbl.TextColor3=theme.Text
                        open=false
                        ListFrame.Visible=false
                        Tween(Arrow,{Rotation=0},0.15)
                        if cfg2.Callback then cfg2.Callback(opt) end
                    end)
                end

                New("TextButton", {
                    Text="", BackgroundTransparency=1,
                    Size=UDim2.new(1,0,1,0), ZIndex=16
                }, HeaderFrame).MouseButton1Click:Connect(function()
                    open=not open
                    ListFrame.Visible=open
                    Tween(Arrow,{Rotation=open and 180 or 0},0.2)
                end)

                local obj={}
                function obj:Set(v) selected=v; SelLbl.Text=v; SelLbl.TextColor3=theme.Text end
                function obj:Get() return selected end
                return obj
            end

            -- ── AddLabel ───────────────────────────
            function SectionObj:AddLabel(cfg2)
                New("TextLabel", {
                    Text=cfg2.Text or "",
                    Font=Enum.Font.Gotham, TextSize=12,
                    TextColor3=cfg2.Color or theme.Placeholder,
                    BackgroundTransparency=1,
                    Size=UDim2.new(1,0,0,20),
                    TextXAlignment=Enum.TextXAlignment.Left,
                    TextWrapped=true, ZIndex=14
                }, SFrame)
            end

            -- ── AddKeybind ─────────────────────────
            function SectionObj:AddKeybind(cfg2)
                local key = cfg2.Default or Enum.KeyCode.Unknown
                local listening = false

                local Row = New("Frame", {
                    Size=UDim2.new(1,0,0,34),
                    BackgroundTransparency=1, ZIndex=14
                }, SFrame)

                New("TextLabel", {
                    Text=cfg2.Name or "Keybind",
                    Font=Enum.Font.Gotham, TextSize=13,
                    TextColor3=theme.Text, BackgroundTransparency=1,
                    Size=UDim2.new(0.6,0,1,0),
                    TextXAlignment=Enum.TextXAlignment.Left, ZIndex=14
                }, Row)

                local KeyBtn = New("TextButton", {
                    Text="["..tostring(key.Name).."]",
                    Font=Enum.Font.GothamBold, TextSize=12,
                    TextColor3=theme.Accent,
                    BackgroundColor3=theme.Background,
                    BackgroundTransparency=0.35,
                    Position=UDim2.new(0.6,0,0.5,0),
                    AnchorPoint=Vector2.new(0,0.5),
                    Size=UDim2.new(0.4,0,0,24), ZIndex=14
                }, Row)
                Corner(KeyBtn,6)

                KeyBtn.MouseButton1Click:Connect(function()
                    listening=true
                    KeyBtn.Text="..."
                    KeyBtn.TextColor3=theme.Placeholder
                end)

                UserInputService.InputBegan:Connect(function(i, gpe)
                    if listening and i.UserInputType==Enum.UserInputType.Keyboard then
                        key=i.KeyCode
                        KeyBtn.Text="["..i.KeyCode.Name.."]"
                        KeyBtn.TextColor3=theme.Accent
                        listening=false
                        if cfg2.Callback then cfg2.Callback(key) end
                    end
                end)

                local obj={}
                function obj:Get() return key end
                return obj
            end

            return SectionObj
        end

        return TabObj
    end

    -- ── Notify ─────────────────────────────────
    function WindowObj:Notify(cfg2)
        local nTime = cfg2.Duration or 4

        local NFrame = New("Frame", {
            Name                   = "Notification",
            AnchorPoint            = Vector2.new(1, 1),
            Position               = UDim2.new(1, 20, 1, -16),
            Size                   = UDim2.new(0, 270, 0, 72),
            BackgroundColor3       = theme.Dialog,
            BackgroundTransparency = 0.1,
            BorderSizePixel        = 0,
            ZIndex                 = 200,
        }, Gui)
        Corner(NFrame, 10)
        Stroke(NFrame, theme.Accent, 1, 0.5)
        Shadow(NFrame)

        -- Accent left bar
        New("Frame", {
            Size=UDim2.new(0,3,0.7,0),
            Position=UDim2.new(0,0,0.15,0),
            BackgroundColor3=theme.Accent,
            ZIndex=201
        }, NFrame)

        New("TextLabel", {
            Text=cfg2.Title or "Notice",
            Font=Enum.Font.GothamBold, TextSize=13,
            TextColor3=theme.Text, BackgroundTransparency=1,
            Position=UDim2.new(0,14,0,8), Size=UDim2.new(1,-20,0,18),
            TextXAlignment=Enum.TextXAlignment.Left, ZIndex=201
        }, NFrame)

        New("TextLabel", {
            Text=cfg2.Message or "",
            Font=Enum.Font.Gotham, TextSize=12,
            TextColor3=theme.Placeholder, BackgroundTransparency=1,
            Position=UDim2.new(0,14,0,28), Size=UDim2.new(1,-20,0,36),
            TextXAlignment=Enum.TextXAlignment.Left,
            TextWrapped=true, ZIndex=201
        }, NFrame)

        Tween(NFrame,{Position=UDim2.new(1,-16,1,-16)},0.35,Enum.EasingStyle.Back,Enum.EasingDirection.Out)

        task.delay(nTime,function()
            Tween(NFrame,{Position=UDim2.new(1,290,1,-16),BackgroundTransparency=1},0.3)
            task.delay(0.35,function() NFrame:Destroy() end)
        end)
    end

    -- ── Destroy ────────────────────────────────
    function WindowObj:Destroy()
        Tween(Main,{BackgroundTransparency=1},0.3)
        Tween(blur,{Size=0},0.4)
        task.delay(0.4,function() Gui:Destroy() end)
    end

    return WindowObj
end

return Da7muUI
