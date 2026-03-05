local Da7muUI = {}
Da7muUI.__index = Da7muUI

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local DEFAULT_THEME = {
    Accent       = Color3.fromRGB(36, 120, 255),
    Background   = Color3.fromRGB(8, 11, 12),
    Dark         = Color3.fromRGB(17, 18, 25),
    Card         = Color3.fromRGB(22, 21, 28),
    Text         = Color3.fromRGB(207, 207, 207),
    SubText      = Color3.fromRGB(105, 105, 112),
    Border       = Color3.fromRGB(29, 29, 33),
}

-- ────────────────────────────────────────────────────────────────────────────────
--  Utility Functions
-- ────────────────────────────────────────────────────────────────────────────────

local function tween(obj, info, props)
    TweenService:Create(obj, info or TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), props):Play()
end

local function create(class, props)
    local inst = Instance.new(class)
    for k, v in pairs(props or {}) do
        if k ~= "Parent" then
            pcall(function() inst[k] = v end)
        end
    end
    if props and props.Parent then
        inst.Parent = props.Parent
    end
    return inst
end

local function makeDraggable(frame)
    local dragging, dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- ────────────────────────────────────────────────────────────────────────────────
--  Window Creation
-- ────────────────────────────────────────────────────────────────────────────────

function Da7muUI:CreateWindow(options)
    options = options or {}
    local self = setmetatable({}, Da7muUI)

    self.Title       = options.Title       or "Da7mu UI"
    self.Icon        = options.Icon        or nil
    self.Author      = options.Author      or ""
    self.Size        = options.Size        or UDim2.fromOffset(900, 650)
    self.MinSize     = options.MinSize     or Vector2.new(700, 500)
    self.MaxSize     = options.MaxSize     or Vector2.new(1200, 800)
    self.Resizable   = options.Resizable   ~= false
    self.Theme       = options.Theme       or DEFAULT_THEME
    self.Blur        = options.Blur        ~= false
    self.Folder      = options.Folder      or "Da7muUI"

    self.Tabs        = {}
    self.CurrentTab  = nil

    self:BuildGui()
    self:ApplyTheme()

    return self
end

function Da7muUI:BuildGui()
    -- ScreenGui
    local sg = create("ScreenGui", {
        Name = "Da7muUI",
        IgnoreGuiInset = true,
        Parent = PlayerGui,
        ResetOnSpawn = false
    })

    -- Main Frame
    local main = create("Frame", {
        Name = "Main",
        Size = self.Size,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(0,0,0),
        BackgroundTransparency = 0.2,
        BorderSizePixel = 0,
        Parent = sg
    })
    create("UICorner", {CornerRadius = UDim.new(0,10), Parent = main})

    -- Navigation (Sidebar)
    local nav = create("Frame", {
        Name = "Navigation",
        Size = UDim2.new(0.14291, 0, 1, -65),
        BackgroundColor3 = self.Theme.Background,
        BackgroundTransparency = 0.6,
        BorderSizePixel = 0,
        Parent = main
    })
    create("UICorner", {Parent = nav})

    -- Hub Icon & Name
    create("ImageLabel", {
        Name = "HubIcon",
        Size = UDim2.new(0,40,0,43),
        Position = UDim2.new(0,10,0,9),
        BackgroundTransparency = 1,
        Image = self.Icon or "rbxassetid://87255886721409", -- placeholder
        Parent = nav
    })

    create("TextLabel", {
        Name = "HubName",
        Size = UDim2.new(0,200,0,50),
        Position = UDim2.new(0,-20,0,0),
        BackgroundTransparency = 1,
        Text = self.Title,
        TextColor3 = self.Theme.Text,
        TextSize = 21,
        FontFace = Font.new("rbxasset://fonts/families/Arial.json", Enum.FontWeight.Bold),
        Parent = nav
    })

    -- Button Holder
    local btnHolder = create("Frame", {
        Name = "ButtonHolder",
        Size = UDim2.new(1,0,0.886,0),
        Position = UDim2.new(0,7,0,60),
        BackgroundTransparency = 1,
        Parent = nav
    })
    create("UIPadding", {PaddingTop = UDim.new(0,8), PaddingBottom = UDim.new(0,8), Parent = btnHolder})
    create("UIListLayout", {Padding = UDim.new(0,1), SortOrder = Enum.SortOrder.LayoutOrder, Parent = btnHolder})

    self.NavButtons = btnHolder

    -- Content Container
    local content = create("Frame", {
        Name = "ContentContainer",
        Size = UDim2.new(0.98209, -206, 1, -72),
        Position = UDim2.new(1,-6,0,66),
        AnchorPoint = Vector2.new(1,0),
        BackgroundTransparency = 1,
        Parent = main
    })

    self.Content = content

    -- Make window draggable
    makeDraggable(main)

    -- Simple resizer (bottom-right corner) - optional
    if self.Resizable then
        local resizer = create("Frame", {
            Size = UDim2.new(0,20,0,20),
            Position = UDim2.new(1,-20,1,-20),
            BackgroundTransparency = 1,
            ZIndex = 10,
            Parent = main
        })
        -- You can expand this with proper resize logic if desired
    end

    -- Store references
    self.ScreenGui = sg
    self.MainFrame = main
    self.NavFrame   = nav
end

function Da7muUI:ApplyTheme()
    local t = self.Theme
    self.MainFrame.BackgroundColor3 = Color3.fromRGB(0,0,0) -- semi-transparent overlay
    self.NavFrame.BackgroundColor3  = t.Background
end

-- ────────────────────────────────────────────────────────────────────────────────
--  Tab System
-- ────────────────────────────────────────────────────────────────────────────────

function Da7muUI:Tab(options)
    options = options or {}
    local tab = {}
    tab.Title   = options.Title or "Tab"
    tab.Icon    = options.Icon  or nil
    tab.Locked  = options.Locked or false

    -- Navigation Button
    local btn = create("TextLabel", {
        Name = tab.Title,
        Size = UDim2.new(1,-14,0,38),
        BackgroundColor3 = Color3.fromRGB(36,36,41),
        BackgroundTransparency = 1,
        Text = tab.Title,
        TextColor3 = Color3.fromRGB(177,177,177),
        TextSize = 17,
        TextXAlignment = Enum.TextXAlignment.Left,
        FontFace = Font.new("rbxasset://fonts/families/Arial.json", Enum.FontWeight.Medium),
        Parent = self.NavButtons
    })
    create("UICorner", {Parent = btn})
    create("UIPadding", {PaddingLeft = UDim.new(0,40), Parent = btn})

    -- Icon
    if tab.Icon then
        create("ImageLabel", {
            Name = "Icon",
            Size = UDim2.new(0,20,0,20),
            Position = UDim2.new(0,-26,0.5,0),
            AnchorPoint = Vector2.new(0,0.5),
            BackgroundTransparency = 1,
            Image = tab.Icon,
            ImageColor3 = Color3.fromRGB(177,177,177),
            Parent = btn
        })
    end

    -- Content Page
    local page = create("ScrollingFrame", {
        Name = tab.Title .. "Tab",
        Size = UDim2.new(1,0,1,0),
        BackgroundTransparency = 1,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = Color3.fromRGB(30,29,39),
        CanvasSize = UDim2.new(0,0,0,0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Visible = false,
        Parent = self.Content
    })
    create("UIPadding", {PaddingLeft = UDim.new(0,18), PaddingRight = UDim.new(0,18), PaddingTop = UDim.new(0,10), Parent = page})
    create("UIListLayout", {Padding = UDim.new(0,12), SortOrder = Enum.SortOrder.LayoutOrder, Parent = page})

    tab.Button = btn
    tab.Page   = page
    tab.Library = self

    table.insert(self.Tabs, tab)

    -- Click handler
    btn.MouseButton1Click:Connect(function()
        if tab.Locked then return end
        for _, t in ipairs(self.Tabs) do
            t.Page.Visible = false
            tween(t.Button, nil, {BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(177,177,177)})
            local icon = t.Button:FindFirstChild("Icon")
            if icon then tween(icon, nil, {ImageColor3 = Color3.fromRGB(177,177,177)}) end
        end
        page.Visible = true
        tween(btn, nil, {BackgroundTransparency = 0.05, TextColor3 = self.Theme.Text})
        local icon = btn:FindFirstChild("Icon")
        if icon then tween(icon, nil, {ImageColor3 = self.Theme.Accent}) end
        self.CurrentTab = tab
    end)

    -- Auto-open first tab
    if #self.Tabs == 1 then
        btn.MouseButton1Click:Fire()
    end

    return tab
end

-- ────────────────────────────────────────────────────────────────────────────────
--  Section
-- ────────────────────────────────────────────────────────────────────────────────

function Da7muUI.Section(tab, options)
    local section = {}
    options = options or {}

    local frame = create("Frame", {
        Name = "Section",
        Size = UDim2.new(1,-5,0,0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = Color3.fromRGB(17,18,25),
        BackgroundTransparency = 0.35,
        Parent = tab.Page
    })
    create("UICorner", {CornerRadius = UDim.new(0,10), Parent = frame})
    create("UIStroke", {Color = Color3.fromRGB(29,29,33), Transparency = 0.47, Thickness = 1.3, Parent = frame})

    create("TextLabel", {
        Name = "Title",
        Size = UDim2.new(1,0,0,30),
        BackgroundTransparency = 1,
        Text = options.Title or "Section",
        TextColor3 = tab.Library.Theme.Text,
        TextSize = 16,
        FontFace = Font.new("Arial", Enum.FontWeight.Bold),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = frame
    })

    local list = create("UIListLayout", {
        Padding = UDim.new(0,8),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = frame
    })
    list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        frame.Size = UDim2.new(1,-5,0,list.AbsoluteContentSize.Y + 40)
    end)

    section.Frame = frame
    section.Tab   = tab

    return section
end

-- Shortcut: Tab:Section({...})
function Da7muUI.Tab:Section(options)
    return Da7muUI.Section(self, options)
end

-- ────────────────────────────────────────────────────────────────────────────────
--  Toggle
-- ────────────────────────────────────────────────────────────────────────────────

function Da7muUI.Toggle(section, options)
    options = options or {}
    local toggle = {}
    local value = options.Default or false
    local callback = options.Callback or function() end

    local frame = create("Frame", {
        Name = "Toggle",
        Size = UDim2.new(1,0,0,32),
        BackgroundTransparency = 1,
        Parent = section.Frame
    })
    create("UICorner", {CornerRadius = UDim.new(0,4), Parent = frame})

    create("TextLabel", {
        Name = "Title",
        Size = UDim2.new(1,-80,1,0),
        BackgroundTransparency = 1,
        Text = options.Title or "Toggle",
        TextColor3 = section.Tab.Library.Theme.Text,
        TextSize = 16,
        FontFace = Font.new("Arial", Enum.FontWeight.Bold),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = frame
    })

    local switch = create("Frame", {
        Name = "Switch",
        Size = UDim2.new(0,45,0,25),
        Position = UDim2.new(1,-55,0.5,0),
        AnchorPoint = Vector2.new(1,0.5),
        BackgroundColor3 = value and Color3.fromRGB(60,95,201) or Color3.fromRGB(12,12,19),
        Parent = frame
    })
    create("UICorner", {CornerRadius = UDim.new(0,20), Parent = switch})

    local circle = create("Frame", {
        Name = "Circle",
        Size = UDim2.new(0,20,0,20),
        Position = value and UDim2.new(0.55,0,0.5,0) or UDim2.new(0,2,0.5,0),
        AnchorPoint = Vector2.new(0,0.5),
        BackgroundColor3 = value and Color3.fromRGB(203,203,199) or Color3.fromRGB(94,109,124),
        Parent = switch
    })
    create("UICorner", {CornerRadius = UDim.new(1,0), Parent = circle})

    local clicking = false
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            clicking = true
        end
    end)
    frame.InputEnded:Connect(function(input)
        if clicking and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            value = not value
            tween(switch, nil, {BackgroundColor3 = value and Color3.fromRGB(60,95,201) or Color3.fromRGB(12,12,19)})
            tween(circle, TweenInfo.new(0.2), {Position = value and UDim2.new(0.55,0,0.5,0) or UDim2.new(0,2,0.5,0)})
            callback(value)
        end
        clicking = false
    end)

    toggle.Value = function() return value end
    toggle.Set = function(v)
        value = v
        tween(switch, nil, {BackgroundColor3 = value and Color3.fromRGB(60,95,201) or Color3.fromRGB(12,12,19)})
        tween(circle, TweenInfo.new(0.2), {Position = value and UDim2.new(0.55,0,0.5,0) or UDim2.new(0,2,0.5,0)})
        callback(value)
    end

    return toggle
end

-- Tab:Toggle({...})
function Da7muUI.Tab:Toggle(options) return Da7muUI.Toggle(self, options) end

-- ────────────────────────────────────────────────────────────────────────────────
--  Slider (very simplified version)
-- ────────────────────────────────────────────────────────────────────────────────

function Da7muUI.Slider(section, options)
    options = options or {}
    local slider = {}
    local min = options.Min or 0
    local max = options.Max or 100
    local val = options.Default or min
    local callback = options.Callback or function() end

    local frame = create("Frame", {
        Name = "Slider",
        Size = UDim2.new(1,0,0,50),
        BackgroundTransparency = 1,
        Parent = section.Frame
    })

    create("TextLabel", {
        Name = "Title",
        Size = UDim2.new(1,0,0,20),
        BackgroundTransparency = 1,
        Text = options.Title or "Slider",
        TextColor3 = section.Tab.Library.Theme.Text,
        TextSize = 16,
        Font = Enum.Font.ArialBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = frame
    })

    local bar = create("Frame", {
        Name = "Bar",
        Size = UDim2.new(1,0,0,6),
        Position = UDim2.new(0,0,0,34),
        BackgroundColor3 = Color3.fromRGB(36,36,41),
        Parent = frame
    })
    create("UICorner", {Parent = bar})

    local fill = create("Frame", {
        Size = UDim2.new((val-min)/(max-min),0,1,0),
        BackgroundColor3 = section.Tab.Library.Theme.Accent,
        Parent = bar
    })
    create("UICorner", {Parent = fill})

    local label = create("TextLabel", {
        Size = UDim2.new(0,50,0,20),
        Position = UDim2.new(1,-55,0,-5),
        BackgroundColor3 = Color3.fromRGB(26,25,32),
        Text = tostring(val),
        TextColor3 = Color3.fromRGB(180,180,180),
        Parent = frame
    })
    create("UICorner", {Parent = label})

    -- Dragging logic (simplified)
    local conn
    bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local function update()
                local mousePos = UserInputService:GetMouseLocation()
                local rel = math.clamp((mousePos.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
                val = math.floor(min + (max - min) * rel + 0.5)
                fill.Size = UDim2.new(rel,0,1,0)
                label.Text = tostring(val)
                callback(val)
            end
            update()
            conn = RunService.RenderStepped:Connect(update)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and conn then
            conn:Disconnect()
            conn = nil
        end
    end)

    slider.Value = function() return val end
    slider.Set = function(v)
        val = math.clamp(v, min, max)
        local ratio = (val - min) / (max - min)
        fill.Size = UDim2.new(ratio, 0, 1, 0)
        label.Text = tostring(val)
        callback(val)
    end

    return slider
end

function Da7muUI.Tab:Slider(options) return Da7muUI.Slider(self, options) end

-- ────────────────────────────────────────────────────────────────────────────────
--  Dropdown (single select only - multi can be added later)
-- ────────────────────────────────────────────────────────────────────────────────

function Da7muUI.Dropdown(section, options)
    options = options or {}
    local dd = {}
    local values = options.Values or {}
    local current = options.Default or values[1]
    local callback = options.Callback or function() end

    local frame = create("Frame", {
        Name = "Dropdown",
        Size = UDim2.new(1,0,0,32),
        BackgroundTransparency = 1,
        Parent = section.Frame
    })

    create("TextLabel", {
        Name = "Title",
        Size = UDim2.new(0.5,0,1,0),
        BackgroundTransparency = 1,
        Text = options.Title or "Dropdown",
        TextColor3 = section.Tab.Library.Theme.Text,
        TextSize = 16,
        Font = Enum.Font.ArialBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = frame
    })

    local box = create("Frame", {
        Size = UDim2.new(0.45,0,0,28),
        Position = UDim2.new(1,-10,0.5,0),
        AnchorPoint = Vector2.new(1,0.5),
        BackgroundColor3 = Color3.fromRGB(26,25,32),
        Parent = frame
    })
    create("UICorner", {CornerRadius = UDim.new(0,5), Parent = box})

    local label = create("TextLabel", {
        Size = UDim2.new(1,-30,1,0),
        BackgroundTransparency = 1,
        Text = current or "Select...",
        TextColor3 = Color3.fromRGB(180,180,180),
        TextSize = 14,
        Parent = box
    })

    -- Dropdown list (hidden by default)
    local listFrame = create("ScrollingFrame", {
        Size = UDim2.new(0.45,0,0,120),
        Position = UDim2.new(1,-10,1,8),
        AnchorPoint = Vector2.new(1,0),
        BackgroundColor3 = Color3.fromRGB(22,21,28),
        CanvasSize = UDim2.new(0,0,0,0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ScrollBarThickness = 4,
        Visible = false,
        ZIndex = 5,
        Parent = frame
    })
    create("UICorner", {Parent = listFrame})
    create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Parent = listFrame})

    for _, v in ipairs(values) do
        local btn = create("TextButton", {
            Size = UDim2.new(1,0,0,28),
            BackgroundTransparency = 1,
            Text = tostring(v),
            TextColor3 = Color3.fromRGB(180,180,180),
            Parent = listFrame
        })
        btn.MouseButton1Click:Connect(function()
            current = v
            label.Text = tostring(v)
            listFrame.Visible = false
            callback(v)
        end)
        btn.MouseEnter:Connect(function() tween(btn, nil, {BackgroundTransparency = 0.85}) end)
        btn.MouseLeave:Connect(function() tween(btn, nil, {BackgroundTransparency = 1}) end)
    end

    box.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            listFrame.Visible = not listFrame.Visible
        end
    end)

    dd.Value = function() return current end
    dd.Set = function(v)
        if table.find(values, v) then
            current = v
            label.Text = tostring(v)
            callback(v)
        end
    end

    return dd
end

function Da7muUI.Tab:Dropdown(options) return Da7muUI.Dropdown(self, options) end

-- Export
return Da7muUI
