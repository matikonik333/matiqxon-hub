if getgenv().MatiqxonKey ~= "Matiqxon_Secure_Pass" then return end

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local existingGUI = CoreGui:FindFirstChild("ESPManagerGUI")
if existingGUI then
    existingGUI:Destroy()
    task.wait(0.1)
end

local ESPSettings = {
    Enabled = true,
    ShowHighlight = true,
    ShowNames = true,
    ShowHealth = true,
    ShowDistance = true,
    MaxDistance = 1000,
    TeamCheck = false
}

local ESPObjects = {}

local isExpanded = true
local isLocked = false
local isGUIVisible = true

local function create(className, properties)
    local instance = Instance.new(className)
    for prop, value in pairs(properties) do
        if prop ~= "Parent" then
            instance[prop] = value
        end
    end
    if properties.Parent then
        instance.Parent = properties.Parent
    end
    return instance
end

local screenGui = create("ScreenGui", {
    Name = "ESPManagerGUI",
    Parent = CoreGui,
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling
})

local eyeButton = create("TextButton", {
    Name = "EyeButton",
    Parent = screenGui,
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.new(0.1, 0, 0.1, 0),
    Size = UDim2.new(0, 38, 0, 38),
    BackgroundColor3 = Color3.fromRGB(50, 50, 50),
    Text = "O",
    TextColor3 = Color3.fromRGB(220, 220, 220),
    TextSize = 17,
    Font = Enum.Font.GothamBold,
    BorderSizePixel = 0,
    ZIndex = 10
})

create("UICorner", {
    Parent = eyeButton,
    CornerRadius = UDim.new(0.5, 0)
})

create("UIStroke", {
    Parent = eyeButton,
    Color = Color3.fromRGB(80, 80, 80),
    Thickness = 1
})

local mainFrame = create("Frame", {
    Name = "MainFrame",
    Parent = screenGui,
    Position = UDim2.new(0.5, -106, 0.1, 0),
    Size = UDim2.new(0, 213, 0, 221),
    BackgroundColor3 = Color3.fromRGB(30, 30, 30),
    BorderSizePixel = 0,
    Active = true,
    Draggable = true
})

create("UICorner", {
    Parent = mainFrame,
    CornerRadius = UDim.new(0, 8)
})

create("UIStroke", {
    Parent = mainFrame,
    Color = Color3.fromRGB(60, 60, 60),
    Thickness = 1
})

local topBar = create("Frame", {
    Name = "TopBar",
    Parent = mainFrame,
    Size = UDim2.new(1, 0, 0, 30),
    BackgroundColor3 = Color3.fromRGB(40, 40, 40),
    BorderSizePixel = 0
})

create("UICorner", {
    Parent = topBar,
    CornerRadius = UDim.new(0, 8)
})

local topBarCover = create("Frame", {
    Parent = topBar,
    Position = UDim2.new(0, 0, 1, -8),
    Size = UDim2.new(1, 0, 0, 8),
    BackgroundColor3 = Color3.fromRGB(40, 40, 40),
    BorderSizePixel = 0
})

local title = create("TextLabel", {
    Parent = topBar,
    Position = UDim2.new(0, 9, 0, 0),
    Size = UDim2.new(1, -60, 1, 0),
    BackgroundTransparency = 1,
    Text = "ESP MANAGER",
    TextColor3 = Color3.fromRGB(200, 200, 200),
    TextSize = 11,
    TextXAlignment = Enum.TextXAlignment.Left,
    Font = Enum.Font.GothamBold
})

local lockButton = create("TextButton", {
    Name = "LockButton",
    Parent = topBar,
    AnchorPoint = Vector2.new(1, 0.5),
    Position = UDim2.new(1, -34, 0.5, 0),
    Size = UDim2.new(0, 22, 0, 22),
    BackgroundColor3 = Color3.fromRGB(50, 50, 50),
    Text = "U",
    TextColor3 = Color3.fromRGB(180, 180, 180),
    TextSize = 10,
    Font = Enum.Font.GothamBold,
    BorderSizePixel = 0
})

create("UICorner", {
    Parent = lockButton,
    CornerRadius = UDim.new(0, 5)
})

local toggleButton = create("TextButton", {
    Parent = topBar,
    AnchorPoint = Vector2.new(1, 0.5),
    Position = UDim2.new(1, -7, 0.5, 0),
    Size = UDim2.new(0, 22, 0, 22),
    BackgroundColor3 = Color3.fromRGB(50, 50, 50),
    Text = "-",
    TextColor3 = Color3.fromRGB(180, 180, 180),
    TextSize = 14,
    Font = Enum.Font.GothamBold,
    BorderSizePixel = 0
})

create("UICorner", {
    Parent = toggleButton,
    CornerRadius = UDim.new(0, 5)
})

local contentFrame = create("Frame", {
    Parent = mainFrame,
    Position = UDim2.new(0, 0, 0, 34),
    Size = UDim2.new(1, 0, 1, -34),
    BackgroundTransparency = 1
})

local scrollingFrame = create("ScrollingFrame", {
    Parent = contentFrame,
    Position = UDim2.new(0, 7, 0, 7),
    Size = UDim2.new(1, -14, 1, -26),
    BackgroundColor3 = Color3.fromRGB(35, 35, 35),
    BorderSizePixel = 0,
    ScrollBarThickness = 3,
    CanvasSize = UDim2.new(0, 0, 0, 0),
    ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80),
    AutomaticCanvasSize = Enum.AutomaticSize.Y
})

create("UICorner", {
    Parent = scrollingFrame,
    CornerRadius = UDim.new(0, 5)
})

create("UIStroke", {
    Parent = scrollingFrame,
    Color = Color3.fromRGB(60, 60, 60),
    Thickness = 1
})

create("UIListLayout", {
    Parent = scrollingFrame,
    SortOrder = Enum.SortOrder.LayoutOrder,
    Padding = UDim.new(0, 7)
})

create("UIPadding", {
    Parent = scrollingFrame,
    PaddingTop = UDim.new(0, 7),
    PaddingBottom = UDim.new(0, 7),
    PaddingLeft = UDim.new(0, 7),
    PaddingRight = UDim.new(0, 7)
})

local creditLabel = create("TextLabel", {
    Name = "CreditLabel",
    Parent = contentFrame,
    Position = UDim2.new(0, 0, 1, -12),
    Size = UDim2.new(1, 0, 0, 12),
    BackgroundTransparency = 1,
    Text = "made by @matiqxon",
    TextColor3 = Color3.fromRGB(120, 120, 120),
    TextSize = 7,
    TextXAlignment = Enum.TextXAlignment.Center,
    Font = Enum.Font.Gotham
})

local function createToggle(name, setting, layoutOrder)
    local toggleFrame = create("Frame", {
        Parent = scrollingFrame,
        Size = UDim2.new(1, -14, 0, 27),
        BackgroundColor3 = Color3.fromRGB(45, 45, 45),
        BorderSizePixel = 0,
        LayoutOrder = layoutOrder
    })
    
    create("UICorner", {
        Parent = toggleFrame,
        CornerRadius = UDim.new(0, 5)
    })
    
    local label = create("TextLabel", {
        Parent = toggleFrame,
        Position = UDim2.new(0, 9, 0, 0),
        Size = UDim2.new(0.7, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = name,
        TextColor3 = Color3.fromRGB(200, 200, 200),
        TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.Gotham
    })
    
    local button = create("TextButton", {
        Parent = toggleFrame,
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -7, 0.5, 0),
        Size = UDim2.new(0, 38, 0, 19),
        BackgroundColor3 = ESPSettings[setting] and Color3.fromRGB(70, 150, 70) or Color3.fromRGB(70, 50, 50),
        Text = ESPSettings[setting] and "ON" or "OFF",
        TextColor3 = Color3.fromRGB(220, 220, 220),
        TextSize = 9,
        Font = Enum.Font.GothamBold,
        BorderSizePixel = 0
    })
    
    create("UICorner", {
        Parent = button,
        CornerRadius = UDim.new(0, 4)
    })
    
    button.MouseButton1Click:Connect(function()
        ESPSettings[setting] = not ESPSettings[setting]
        button.BackgroundColor3 = ESPSettings[setting] and Color3.fromRGB(70, 150, 70) or Color3.fromRGB(70, 50, 50)
        button.Text = ESPSettings[setting] and "ON" or "OFF"
    end)
    
    return toggleFrame
end

createToggle("ESP Enabled", "Enabled", 1)
createToggle("Show Highlight", "ShowHighlight", 2)
createToggle("Show Names", "ShowNames", 3)
createToggle("Show Health", "ShowHealth", 4)
createToggle("Show Distance", "ShowDistance", 5)
createToggle("Team Check", "TeamCheck", 6)

local function createDrawing(type, properties)
    local drawing = Drawing.new(type)
    for prop, value in pairs(properties) do
        drawing[prop] = value
    end
    return drawing
end

local function getTeamColor(player)
    if player.Team then
        return player.TeamColor.Color
    end
    return Color3.fromRGB(255, 255, 255)
end

local function createESP(player)
    if player == LocalPlayer then return end
    
    local esp = {
        Player = player,
        Highlight = nil,
        DisplayNameText = createDrawing("Text", {
            Size = 13,
            Center = true,
            Outline = true,
            Color = Color3.fromRGB(255, 255, 255),
            Visible = false,
            ZIndex = 2,
            Font = 2
        }),
        UsernameText = createDrawing("Text", {
            Size = 12,
            Center = true,
            Outline = true,
            Color = Color3.fromRGB(255, 255, 255),
            Visible = false,
            ZIndex = 2,
            Font = 2
        }),
        HealthText = createDrawing("Text", {
            Size = 13,
            Center = true,
            Outline = true,
            Color = Color3.fromRGB(0, 255, 0),
            Visible = false,
            ZIndex = 2,
            Font = 2
        }),
        DistanceText = createDrawing("Text", {
            Size = 13,
            Center = true,
            Outline = true,
            Color = Color3.fromRGB(200, 200, 200),
            Visible = false,
            ZIndex = 2,
            Font = 2
        }),
        CharacterConnection = nil
    }
    
    local function setupHighlight(character)
        if esp.Highlight then
            esp.Highlight:Destroy()
        end
        
        local teamColor = getTeamColor(player)
        
        local highlight = Instance.new("Highlight")
        highlight.Name = "ESPHighlight"
        highlight.Adornee = character
        highlight.FillColor = teamColor
        highlight.OutlineColor = teamColor
        highlight.FillTransparency = 0.5
        highlight.OutlineTransparency = 0
        highlight.Enabled = false
        highlight.Parent = character
        
        esp.Highlight = highlight
    end
    
    if player.Character then
        setupHighlight(player.Character)
    end
    
    esp.CharacterConnection = player.CharacterAdded:Connect(function(character)
        setupHighlight(character)
    end)
    
    ESPObjects[player] = esp
end

local function removeESP(player)
    local esp = ESPObjects[player]
    if esp then
        if esp.Highlight then
            esp.Highlight:Destroy()
        end
        esp.DisplayNameText:Remove()
        esp.UsernameText:Remove()
        esp.HealthText:Remove()
        esp.DistanceText:Remove()
        if esp.CharacterConnection then
            esp.CharacterConnection:Disconnect()
        end
        ESPObjects[player] = nil
    end
end

local function updateESP()
    for player, esp in pairs(ESPObjects) do
        if not player or not player.Parent then
            removeESP(player)
            continue
        end
        
        local character = player.Character
        local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
        local humanoid = character and character:FindFirstChild("Humanoid")
        
        if not character or not humanoidRootPart or not humanoid or humanoid.Health <= 0 then
            if esp.Highlight then
                esp.Highlight.Enabled = false
            end
            esp.DisplayNameText.Visible = false
            esp.UsernameText.Visible = false
            esp.HealthText.Visible = false
            esp.DistanceText.Visible = false
            continue
        end
        
        if ESPSettings.TeamCheck and player.Team == LocalPlayer.Team then
            if esp.Highlight then
                esp.Highlight.Enabled = false
            end
            esp.DisplayNameText.Visible = false
            esp.UsernameText.Visible = false
            esp.HealthText.Visible = false
            esp.DistanceText.Visible = false
            continue
        end
        
        local distance = (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")) 
            and (LocalPlayer.Character.HumanoidRootPart.Position - humanoidRootPart.Position).Magnitude or 0
        
        if distance > ESPSettings.MaxDistance then
            if esp.Highlight then
                esp.Highlight.Enabled = false
            end
            esp.DisplayNameText.Visible = false
            esp.UsernameText.Visible = false
            esp.HealthText.Visible = false
            esp.DistanceText.Visible = false
            continue
        end
        
        local vector, onScreen = Camera:WorldToViewportPoint(humanoidRootPart.Position)
        
        if onScreen and ESPSettings.Enabled then
            local teamColor = getTeamColor(player)
            
            if ESPSettings.ShowHighlight and esp.Highlight then
                esp.Highlight.Enabled = true
                esp.Highlight.FillColor = teamColor
                esp.Highlight.OutlineColor = teamColor
            elseif esp.Highlight then
                esp.Highlight.Enabled = false
            end
            
            local headPos = Camera:WorldToViewportPoint(character.Head.Position + Vector3.new(0, 0.5, 0))
            local legPos = Camera:WorldToViewportPoint(humanoidRootPart.Position - Vector3.new(0, 3, 0))
            local height = math.abs(headPos.Y - legPos.Y)
            
            if ESPSettings.ShowNames then
                local displayName = player.DisplayName
                local username = "@" .. player.Name
                
                esp.DisplayNameText.Text = displayName
                esp.DisplayNameText.Position = Vector2.new(vector.X, vector.Y - height / 2 - 28)
                esp.DisplayNameText.Color = teamColor
                esp.DisplayNameText.Visible = true
                
                esp.UsernameText.Text = username
                esp.UsernameText.Position = Vector2.new(vector.X, vector.Y - height / 2 - 14)
                esp.UsernameText.Color = teamColor
                esp.UsernameText.Visible = true
            else
                esp.DisplayNameText.Visible = false
                esp.UsernameText.Visible = false
            end
            
            if ESPSettings.ShowHealth then
                local health = math.floor(humanoid.Health)
                local maxHealth = math.floor(humanoid.MaxHealth)
                esp.HealthText.Text = health .. " HP"
                esp.HealthText.Position = Vector2.new(vector.X, vector.Y + height / 2 + 2)
                esp.HealthText.Color = Color3.fromRGB(
                    255 * (1 - health / maxHealth),
                    255 * (health / maxHealth),
                    0
                )
                esp.HealthText.Visible = true
            else
                esp.HealthText.Visible = false
            end
            
            if ESPSettings.ShowDistance then
                esp.DistanceText.Text = math.floor(distance) .. " studs"
                esp.DistanceText.Position = Vector2.new(vector.X, vector.Y + height / 2 + 16)
                esp.DistanceText.Color = teamColor
                esp.DistanceText.Visible = true
            else
                esp.DistanceText.Visible = false
            end
        else
            if esp.Highlight then
                esp.Highlight.Enabled = false
            end
            esp.DisplayNameText.Visible = false
            esp.UsernameText.Visible = false
            esp.HealthText.Visible = false
            esp.DistanceText.Visible = false
        end
    end
end

for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        createESP(player)
    end
end

Players.PlayerAdded:Connect(function(player)
    createESP(player)
end)

Players.PlayerRemoving:Connect(function(player)
    removeESP(player)
end)

RunService.RenderStepped:Connect(function()
    updateESP()
end)

eyeButton.MouseButton1Click:Connect(function()
    isGUIVisible = not isGUIVisible
    mainFrame.Visible = isGUIVisible
    
    if isGUIVisible then
        eyeButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    else
        eyeButton.BackgroundColor3 = Color3.fromRGB(80, 50, 50)
    end
end)

lockButton.MouseButton1Click:Connect(function()
    isLocked = not isLocked
    lockButton.Text = isLocked and "L" or "U"
    lockButton.BackgroundColor3 = isLocked and Color3.fromRGB(80, 50, 50) or Color3.fromRGB(50, 50, 50)
    mainFrame.Draggable = not isLocked
end)

toggleButton.MouseButton1Click:Connect(function()
    isExpanded = not isExpanded
    
    local targetSize = isExpanded and UDim2.new(0, 213, 0, 221) or UDim2.new(0, 213, 0, 34)
    
    mainFrame:TweenSize(targetSize, Enum.EasingDirection.Out, Enum.EasingStyle.Quint, 0.3, true)
    
    toggleButton.Text = isExpanded and "-" or "+"
    contentFrame.Visible = isExpanded
end)

