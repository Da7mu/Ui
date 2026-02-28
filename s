-- Da7muUI - Modern UI Library with Blur Effects
local Da7muUI = {}
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Player = Players.LocalPlayer

-- Create GUI holder
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Da7muUI"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

-- Add blur effect
local blurEffect = Instance.new("BlurEffect")
blurEffect.Name = "Da7muBlur"
blurEffect.Size = 0
blurEffect.Parent = game:GetService("Lighting")

-- Color utilities
function Da7muUI:Gradient(colorStops, options)
    return {
        Type = "Gradient",
        ColorStops = colorStops,
        Options = options or {}
    }
end

-- Theme management
Da7muUI.Themes = {
    Default = {
        Accent = Color3.fromRGB(0, 170, 255),
        Background = Color3.fromRGB(20, 20, 30),
        Dialog = Color3.fromRGB(30, 30, 40),
        Outline = Color3.fromRGB(255, 255, 255),
        Text = Color3.fromRGB(255, 255, 255),
        Placeholder = Color3.fromRGB(150, 150, 150),
        Button = Color3.fromRGB(0, 170, 255),
        Icon = Color3.fromRGB(255, 255, 255),
        Transparency = 0.15,
        ShadowTransparency = 0.3
    }
}

function Da7muUI:AddTheme(themeData)
    Da7muUI.Themes[themeData.Name] = themeData
end

-- Create UI Elements
function Da7muUI:CreateWindow(options)
    options = options or {}
    
    -- Create main frame with modern blur effects
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainWindow"
    MainFrame.Size = options.Size or UDim2.fromOffset(580, 460)
    MainFrame.Position = UDim2.new(0.5, -290, 0.5, -230)
    MainFrame.BackgroundColor3 = Da7muUI.Themes[options.Theme or "Default"].Background
    MainFrame.BackgroundTransparency = options.Transparent and 0.15 or 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui
    
    -- Rounded corners
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = MainFrame
    
    -- Shadow effect
    local Shadow = Instance.new("ImageLabel")
    Shadow.Name = "Shadow"
    Shadow.Size = UDim2.new(1, 40, 1, 40)
    Shadow.Position = UDim2.new(0, -20, 0, -20)
    Shadow.BackgroundTransparency = 1
    Shadow.Image = "rbxassetid://6014261993"
    Shadow.ImageColor3 = Color3.new(0, 0, 0)
    Shadow.ImageTransparency = 0.3
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(10, 10, 118, 118)
    Shadow.Parent = MainFrame
    
    -- Background image if provided
    if options.Background then
        local BackgroundImage = Instance.new("ImageLabel")
        BackgroundImage.Name = "BackgroundImage"
        BackgroundImage.Size = UDim2.new(1, 0, 1, 0)
        BackgroundImage.BackgroundTransparency = 1
        BackgroundImage.Image = options.Background
        BackgroundImage.ImageTransparency = options.BackgroundImageTransparency or 0
        BackgroundImage.Parent = MainFrame
    end
    
    -- Title bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 40)
    TitleBar.BackgroundColor3 = Da7muUI.Themes[options.Theme or "Default"].Dialog
    TitleBar.BackgroundTransparency = 0.2
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = MainFrame
    
    local TitleBarCorner = Instance.new("UICorner")
    TitleBarCorner.CornerRadius = UDim.new(0, 12)
    TitleBarCorner.Parent = TitleBar
    
    -- Title bar inner corner (to only round top)
    local TitleBarTopCorner = Instance.new("UICorner")
    TitleBarTopCorner.CornerRadius = UDim.new(0, 12)
    
    -- Icon
    if options.Icon then
        local Icon = Instance.new("ImageLabel")
        Icon.Name = "Icon"
        Icon.Size = UDim2.new(0, options.IconSize or 30, 0, options.IconSize or 30)
        Icon.Position = UDim2.new(0, 10, 0.5, -(options.IconSize or 30)/2)
        Icon.BackgroundTransparency = 1
        Icon.Image = options.Icon
        Icon.Parent = TitleBar
    end
    
    -- Title
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(0, 200, 1, 0)
    Title.Position = UDim2.new(0, (options.Icon and 50 or 15), 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = options.Title or "Da7mu Hub"
    Title.TextColor3 = Da7muUI.Themes[options.Theme or "Default"].Text
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 16
    Title.Parent = TitleBar
    
    -- Author
    if options.Author then
        local Author = Instance.new("TextLabel")
        Author.Name = "Author"
        Author.Size = UDim2.new(0, 150, 1, 0)
        Author.Position = UDim2.new(1, -160, 0, 0)
        Author.BackgroundTransparency = 1
        Author.Text = options.Author
        Author.TextColor3 = Da7muUI.Themes[options.Theme or "Default"].Placeholder
        Author.TextXAlignment = Enum.TextXAlignment.Right
        Author.Font = Enum.Font.Gotham
        Author.TextSize = 12
        Author.Parent = TitleBar
    end
    
    -- User icon
    if options.User and options.User.Enabled then
        local UserIcon = Instance.new("ImageButton")
        UserIcon.Name = "UserIcon"
        UserIcon.Size = UDim2.new(0, 30, 0, 30)
        UserIcon.Position = UDim2.new(1, -45, 0.5, -15)
        UserIcon.BackgroundTransparency = 1
        UserIcon.Image = "rbxassetid://6031094678"
        UserIcon.ImageColor3 = Da7muUI.Themes[options.Theme or "Default"].Icon
        UserIcon.Parent = TitleBar
        
        UserIcon.MouseButton1Click:Connect(function()
            if options.User.Callback then
                options.User.Callback()
            end
        end)
    end
    
    -- Sidebar
    local SideBar = Instance.new("Frame")
    SideBar.Name = "SideBar"
    SideBar.Size = UDim2.new(0, options.SideBarWidth or 180, 1, -40)
    SideBar.Position = UDim2.new(0, 0, 0, 40)
    SideBar.BackgroundColor3 = Da7muUI.Themes[options.Theme or "Default"].Dialog
    SideBar.BackgroundTransparency = 0.15
    SideBar.BorderSizePixel = 0
    SideBar.Parent = MainFrame
    
    local SideBarCorner = Instance.new("UICorner")
    SideBarCorner.CornerRadius = UDim.new(0, 8)
    SideBarCorner.Parent = SideBar
    
    -- Content container
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Size = UDim2.new(1, -(options.SideBarWidth or 180), 1, -40)
    ContentContainer.Position = UDim2.new(1, -(options.SideBarWidth or 180), 0, 40)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Parent = MainFrame
    
    -- Tabs container (sidebar)
    local TabsContainer = Instance.new("ScrollingFrame")
    TabsContainer.Name = "TabsContainer"
    TabsContainer.Size = UDim2.new(1, -10, 1, -20)
    TabsContainer.Position = UDim2.new(0, 5, 0, 10)
    TabsContainer.BackgroundTransparency = 1
    TabsContainer.BorderSizePixel = 0
    TabsContainer.ScrollBarThickness = 4
    TabsContainer.ScrollBarImageColor3 = Da7muUI.Themes[options.Theme or "Default"].Accent
    TabsContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabsContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
    TabsContainer.Parent = SideBar
    
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Padding = UDim.new(0, 5)
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Parent = TabsContainer
    
    -- Main content
    local MainContent = Instance.new("Frame")
    MainContent.Name = "MainContent"
    MainContent.Size = UDim2.new(1, 0, 1, 0)
    MainContent.BackgroundTransparency = 1
    MainContent.Parent = ContentContainer
    
    -- Page container
    local PageContainer = Instance.new("Frame")
    PageContainer.Name = "PageContainer"
    PageContainer.Size = UDim2.new(1, 0, 1, 0)
    PageContainer.BackgroundTransparency = 1
    PageContainer.Parent = MainContent
    
    -- Tween blur in
    TweenService:Create(blurEffect, TweenInfo.new(0.5), {Size = 24}):Play()
    
    -- Dragging functionality
    local dragging = false
    local dragInput
    local dragStart
    local startPos
    
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    TitleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    -- Window methods
    local WindowAPI = {}
    
    function WindowAPI:Tab(options)
        options = options or {}
        
        local TabButton = Instance.new("TextButton")
        TabButton.Name = options.Title or "Tab"
        TabButton.Size = UDim2.new(1, -10, 0, 40)
        TabButton.BackgroundColor3 = Da7muUI.Themes[options.Theme or "Default"].Dialog
        TabButton.BackgroundTransparency = options.Selected and 0.05 or 0.15
        TabButton.BorderSizePixel = 0
        TabButton.Text = ""
        TabButton.AutoButtonColor = false
        TabButton.Parent = TabsContainer
        
        local TabButtonCorner = Instance.new("UICorner")
        TabButtonCorner.CornerRadius = UDim.new(0, 8)
        TabButtonCorner.Parent = TabButton
        
        -- Icon
        if options.Icon then
            local Icon = Instance.new("ImageLabel")
            Icon.Name = "Icon"
            Icon.Size = UDim2.new(0, 20, 0, 20)
            Icon.Position = UDim2.new(0, 10, 0.5, -10)
            Icon.BackgroundTransparency = 1
            Icon.Image = "rbxassetid://" .. (options.Icon == "house" and "6031094678" or "6031094678")
            Icon.ImageColor3 = Da7muUI.Themes[options.Theme or "Default"].Icon
            Icon.Parent = TabButton
        end
        
        -- Title
        local TabTitle = Instance.new("TextLabel")
        TabTitle.Name = "Title"
        TabTitle.Size = UDim2.new(1, -40, 1, 0)
        TabTitle.Position = UDim2.new(0, 40, 0, 0)
        TabTitle.BackgroundTransparency = 1
        TabTitle.Text = options.Title or "Tab"
        TabTitle.TextColor3 = Da7muUI.Themes[options.Theme or "Default"].Text
        TabTitle.TextXAlignment = Enum.TextXAlignment.Left
        TabTitle.Font = Enum.Font.Gotham
        TabTitle.TextSize = 14
        TabTitle.Parent = TabButton
        
        -- Description
        if options.Desc then
            local Desc = Instance.new("TextLabel")
            Desc.Name = "Description"
            Desc.Size = UDim2.new(1, -40, 1, 0)
            Desc.Position = UDim2.new(0, 40, 0, 0)
            Desc.BackgroundTransparency = 1
            Desc.Text = options.Desc
            Desc.TextColor3 = Da7muUI.Themes[options.Theme or "Default"].Placeholder
            Desc.TextXAlignment = Enum.TextXAlignment.Left
            Desc.Font = Enum.Font.Gotham
            Desc.TextSize = 10
            Desc.Visible = false
            Desc.Parent = TabButton
        end
        
        -- Page for this tab
        local TabPage = Instance.new("ScrollingFrame")
        TabPage.Name = options.Title or "Page"
        TabPage.Size = UDim2.new(1, 0, 1, 0)
        TabPage.BackgroundTransparency = 1
        TabPage.BorderSizePixel = 0
        TabPage.ScrollBarThickness = 4
        TabPage.ScrollBarImageColor3 = Da7muUI.Themes[options.Theme or "Default"].Accent
        TabPage.Visible = options.Selected or false
        TabPage.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabPage.AutomaticCanvasSize = Enum.AutomaticSize.Y
        TabPage.Parent = PageContainer
        
        local PageLayout = Instance.new("UIListLayout")
        PageLayout.Padding = UDim.new(0, 10)
        PageLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        PageLayout.Parent = TabPage
        
        -- Tab selection
        TabButton.MouseButton1Click:Connect(function()
            for _, child in pairs(PageContainer:GetChildren()) do
                if child:IsA("ScrollingFrame") then
                    child.Visible = false
                end
            end
            for _, child in pairs(TabsContainer:GetChildren()) do
                if child:IsA("TextButton") then
                    child.BackgroundTransparency = 0.15
                end
            end
            TabButton.BackgroundTransparency = 0.05
            TabPage.Visible = true
        end)
        
        -- Tab methods
        local TabAPI = {}
        
        function TabAPI:MultiSection(options)
            options = options or {}
            
            local MultiSectionFrame = Instance.new("Frame")
            MultiSectionFrame.Name = options.Title or "MultiSection"
            MultiSectionFrame.Size = UDim2.new(1, -20, 0, 50)
            MultiSectionFrame.BackgroundColor3 = Da7muUI.Themes[options.Theme or "Default"].Dialog
            MultiSectionFrame.BackgroundTransparency = 0.15
            MultiSectionFrame.Parent = TabPage
            
            local MultiSectionCorner = Instance.new("UICorner")
            MultiSectionCorner.CornerRadius = UDim.new(0, 8)
            MultiSectionCorner.Parent = MultiSectionFrame
            
            -- Title
            local SectionTitle = Instance.new("TextLabel")
            SectionTitle.Name = "Title"
            SectionTitle.Size = UDim2.new(1, -50, 0, 30)
            SectionTitle.Position = UDim2.new(0, 15, 0, 10)
            SectionTitle.BackgroundTransparency = 1
            SectionTitle.Text = options.Title or "Section"
            SectionTitle.TextColor3 = Da7muUI.Themes[options.Theme or "Default"].Text
            SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
            SectionTitle.Font = Enum.Font.GothamBold
            SectionTitle.TextSize = 16
            SectionTitle.Parent = MultiSectionFrame
            
            -- Sections container
            local SectionsContainer = Instance.new("Frame")
            SectionsContainer.Name = "SectionsContainer"
            SectionsContainer.Size = UDim2.new(1, -30, 1, -50)
            SectionsContainer.Position = UDim2.new(0, 15, 0, 50)
            SectionsContainer.BackgroundTransparency = 1
            SectionsContainer.Visible = options.Opened or false
            SectionsContainer.Parent = MultiSectionFrame
            
            local SectionsLayout = Instance.new("UIListLayout")
            SectionsLayout.Padding = UDim.new(0, 5)
            SectionsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
            SectionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
            SectionsLayout.Parent = SectionsContainer
            
            -- Toggle button
            local ToggleButton = Instance.new("ImageButton")
            ToggleButton.Name = "Toggle"
            ToggleButton.Size = UDim2.new(0, 30, 0, 30)
            ToggleButton.Position = UDim2.new(1, -45, 0, 10)
            ToggleButton.BackgroundTransparency = 1
            ToggleButton.Image = "rbxassetid://6031094678"
            ToggleButton.ImageColor3 = Da7muUI.Themes[options.Theme or "Default"].Icon
            ToggleButton.Rotation = options.Opened and 90 or 0
            ToggleButton.Parent = MultiSectionFrame
            
            ToggleButton.MouseButton1Click:Connect(function()
                SectionsContainer.Visible = not SectionsContainer.Visible
                ToggleButton.Rotation = SectionsContainer.Visible and 90 or 0
                MultiSectionFrame.Size = SectionsContainer.Visible and UDim2.new(1, -20, 0, 50 + SectionsContainer.AbsoluteSize.Y) or UDim2.new(1, -20, 0, 50)
            end)
            
            -- MultiSection methods
            local MultiSectionAPI = {}
            
            function MultiSectionAPI:Tab(options)
                options = options or {}
                
                local SubTabButton = Instance.new("TextButton")
                SubTabButton.Name = options.Title or "SubTab"
                SubTabButton.Size = UDim2.new(0, 150, 0, 35)
                SubTabButton.BackgroundColor3 = Da7muUI.Themes[options.Theme or "Default"].Dialog
                SubTabButton.BackgroundTransparency = 0.2
                SubTabButton.BorderSizePixel = 0
                SubTabButton.Text = ""
                SubTabButton.AutoButtonColor = false
                SubTabButton.Parent = SectionsContainer
                
                local SubTabCorner = Instance.new("UICorner")
                SubTabCorner.CornerRadius = UDim.new(0, 6)
                SubTabCorner.Parent = SubTabButton
                
                -- Icon
                if options.Icon then
                    local Icon = Instance.new("ImageLabel")
                    Icon.Name = "Icon"
                    Icon.Size = UDim2.new(0, 20, 0, 20)
                    Icon.Position = UDim2.new(0, 10, 0.5, -10)
                    Icon.BackgroundTransparency = 1
                    Icon.Image = "rbxassetid://6031094678"
                    Icon.ImageColor3 = Da7muUI.Themes[options.Theme or "Default"].Icon
                    Icon.Parent = SubTabButton
                end
                
                -- Title
                local SubTabTitle = Instance.new("TextLabel")
                SubTabTitle.Name = "Title"
                SubTabTitle.Size = UDim2.new(1, -20, 1, 0)
                SubTabTitle.Position = UDim2.new(0, 40, 0, 0)
                SubTabTitle.BackgroundTransparency = 1
                SubTabTitle.Text = options.Title or "SubTab"
                SubTabTitle.TextColor3 = Da7muUI.Themes[options.Theme or "Default"].Text
                SubTabTitle.TextXAlignment = Enum.TextXAlignment.Left
                SubTabTitle.Font = Enum.Font.Gotham
                SubTabTitle.TextSize = 12
                SubTabTitle.Parent = SubTabButton
                
                -- Sub page
                local SubPage = Instance.new("Frame")
                SubPage.Name = options.Title or "SubPage"
                SubPage.Size = UDim2.new(1, 0, 0, 200)
                SubPage.BackgroundTransparency = 1
                SubPage.Visible = options.Selected or false
                SubPage.Parent = PageContainer
                
                SubTabButton.MouseButton1Click:Connect(function()
                    for _, child in pairs(PageContainer:GetChildren()) do
                        if child:IsA("Frame") then
                            child.Visible = false
                        end
                    end
                    SubPage.Visible = true
                end)
                
                return {
                    Page = SubPage
                }
            end
            
            return MultiSectionAPI
        end
        
        function TabAPI:AddSection(options)
            options = options or {}
            
            local SectionFrame = Instance.new("Frame")
            SectionFrame.Name = options.Title or "Section"
            SectionFrame.Size = UDim2.new(1, -20, 0, 100)
            SectionFrame.BackgroundColor3 = Da7muUI.Themes[options.Theme or "Default"].Dialog
            SectionFrame.BackgroundTransparency = 0.15
            SectionFrame.Parent = TabPage
            
            local SectionCorner = Instance.new("UICorner")
            SectionCorner.CornerRadius = UDim.new(0, 8)
            SectionCorner.Parent = SectionFrame
            
            -- Title
            local SectionTitle = Instance.new("TextLabel")
            SectionTitle.Name = "Title"
            SectionTitle.Size = UDim2.new(1, -30, 0, 30)
            SectionTitle.Position = UDim2.new(0, 15, 0, 10)
            SectionTitle.BackgroundTransparency = 1
            SectionTitle.Text = options.Title or "Section"
            SectionTitle.TextColor3 = Da7muUI.Themes[options.Theme or "Default"].Text
            SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
            SectionTitle.Font = Enum.Font.GothamBold
            SectionTitle.TextSize = 16
            SectionTitle.Parent = SectionFrame
            
            return SectionFrame
        end
        
        return TabAPI
    end
    
    function WindowAPI:Tag(options)
        options = options or {}
        
        local TagFrame = Instance.new("Frame")
        TagFrame.Name = "Tag"
        TagFrame.Size = UDim2.new(0, 60, 0, 25)
        TagFrame.Position = UDim2.new(1, -70, 0, 10)
        TagFrame.BackgroundColor3 = options.Color or Color3.fromRGB(51, 221, 255)
        TagFrame.BackgroundTransparency = 0.2
        TagFrame.Parent = TitleBar
        
        local TagCorner = Instance.new("UICorner")
        TagCorner.CornerRadius = UDim.new(0, options.Radius or 12)
        TagCorner.Parent = TagFrame
        
        local TagText = Instance.new("TextLabel")
        TagText.Name = "Text"
        TagText.Size = UDim2.new(1, 0, 1, 0)
        TagText.BackgroundTransparency = 1
        TagText.Text = options.Title or "TAG"
        TagText.TextColor3 = Color3.fromRGB(255, 255, 255)
        TagText.Font = Enum.Font.GothamBold
        TagText.TextSize = 12
        TagText.Parent = TagFrame
    end
    
    return WindowAPI
end

return Da7muUI
