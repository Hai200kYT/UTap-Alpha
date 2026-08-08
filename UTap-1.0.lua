local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local GuiParent = (gethui and gethui()) or game:GetService("CoreGui")

if GuiParent:FindFirstChild("UTap_Menu") then
    GuiParent.UTap_Menu:Destroy()
end

local Config = {
    Aimbot = false,
    WallCheck = false,
    Smoothness = 5,
    FOV = 100,
    Always = false,
    DrawFOV = true,
    
    ESP_Chams = false,
    ESP_Names = false,
    ESP_Box = false,
    ESP_Item = false,
    ESP_Health = false,
    ESP_Distance = false,
    
    ViewModel_Enable = false,
    ViewModel_X = 0,
    ViewModel_Y = 0,
    ViewModel_Z = 0,
    
    Speedhack = false,
    SpeedValue = 32,
    InfJump = false
}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UTap_Menu"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = GuiParent

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Name = "UTap_Toggle"
ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleBtn.Position = UDim2.new(0, 10, 0.3, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(30, 34, 40)
ToggleBtn.BorderColor3 = Color3.fromRGB(224, 159, 62)
ToggleBtn.BorderSizePixel = 2
ToggleBtn.Text = "UTap"
ToggleBtn.TextColor3 = Color3.fromRGB(224, 159, 62)
ToggleBtn.TextSize = 14
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.Active = true
ToggleBtn.Draggable = true
ToggleBtn.Parent = ScreenGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 540, 0, 400)
MainFrame.Position = UDim2.new(0.5, -270, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 28, 33)
MainFrame.BorderColor3 = Color3.fromRGB(45, 50, 58)
MainFrame.BorderSizePixel = 1
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Color3.fromRGB(20, 22, 26)
TopBar.BorderColor3 = Color3.fromRGB(45, 50, 58)
TopBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 100, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "UTap"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 20
Title.Font = Enum.Font.SourceSansBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

local OrangeBar = Instance.new("Frame")
OrangeBar.Size = UDim2.new(1, 0, 0, 2)
OrangeBar.Position = UDim2.new(0, 0, 1, -2)
OrangeBar.BackgroundColor3 = Color3.fromRGB(224, 159, 62)
OrangeBar.BorderSizePixel = 0
OrangeBar.Parent = TopBar

local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(1, -120, 1, 0)
TabContainer.Position = UDim2.new(0, 120, 0, 0)
TabContainer.BackgroundTransparency = 1
TabContainer.Parent = TopBar

local TabLayout = Instance.new("UIListLayout")
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabLayout.Padding = UDim.new(0, 5)
TabLayout.Parent = TabContainer

local ContentContainer = Instance.new("Frame")
ContentContainer.Size = UDim2.new(1, -20, 1, -55)
ContentContainer.Position = UDim2.new(0, 10, 0, 48)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = MainFrame

local Pages = {}

local function CreateTab(name, order)
    local TabBtn = Instance.new("TextButton")
    TabBtn.Size = UDim2.new(0, 80, 1, 0)
    TabBtn.BackgroundTransparency = 1
    TabBtn.Text = name
    TabBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
    TabBtn.TextSize = 14
    TabBtn.Font = Enum.Font.SourceSansBold
    TabBtn.LayoutOrder = order
    TabBtn.Parent = TabContainer

    local Page = Instance.new("ScrollingFrame")
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.ScrollBarThickness = 3
    Page.ScrollBarImageColor3 = Color3.fromRGB(224, 159, 62)
    Page.CanvasSize = UDim2.new(0, 0, 0, 0)
    Page.Parent = ContentContainer

    local PageLayout = Instance.new("UIListLayout")
    PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    PageLayout.Padding = UDim.new(0, 8)
    PageLayout.Parent = Page

    PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Page.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 10)
    end)

    TabBtn.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages) do
            p.Page.Visible = false
            p.Btn.TextColor3 = Color3.fromRGB(150, 150, 150)
        end
        Page.Visible = true
        TabBtn.TextColor3 = Color3.fromRGB(224, 159, 62)
    end)

    Pages[name] = {Page = Page, Btn = TabBtn}
    return Page
end

local AimbotPage = CreateTab("Aimbot", 1)
local VisualsPage = CreateTab("Visuals", 2)
local MiscPage = CreateTab("Misc", 3)

Pages["Aimbot"].Page.Visible = true
Pages["Aimbot"].Btn.TextColor3 = Color3.fromRGB(224, 159, 62)

local function CreateSection(parent, titleText)
    local SectionFrame = Instance.new("Frame")
    SectionFrame.Size = UDim2.new(1, -6, 0, 30)
    SectionFrame.BackgroundColor3 = Color3.fromRGB(30, 34, 40)
    SectionFrame.BorderColor3 = Color3.fromRGB(45, 50, 58)
    SectionFrame.Parent = parent

    local SecTopBar = Instance.new("Frame")
    SecTopBar.Size = UDim2.new(1, 0, 0, 2)
    SecTopBar.BackgroundColor3 = Color3.fromRGB(224, 159, 62)
    SecTopBar.BorderSizePixel = 0
    SecTopBar.Parent = SectionFrame

    local SecTitle = Instance.new("TextLabel")
    SecTitle.Size = UDim2.new(1, -10, 0, 20)
    SecTitle.Position = UDim2.new(0, 8, 0, 4)
    SecTitle.BackgroundTransparency = 1
    SecTitle.Text = titleText
    SecTitle.TextColor3 = Color3.fromRGB(224, 159, 62)
    SecTitle.TextSize = 13
    SecTitle.Font = Enum.Font.SourceSansBold
    SecTitle.TextXAlignment = Enum.TextXAlignment.Left
    SecTitle.Parent = SectionFrame

    local SecContainer = Instance.new("Frame")
    SecContainer.Size = UDim2.new(1, -16, 1, -26)
    SecContainer.Position = UDim2.new(0, 8, 0, 24)
    SecContainer.BackgroundTransparency = 1
    SecContainer.Parent = SectionFrame

    local SecLayout = Instance.new("UIListLayout")
    SecLayout.SortOrder = Enum.SortOrder.LayoutOrder
    SecLayout.Padding = UDim.new(0, 6)
    SecLayout.Parent = SecContainer

    SecLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        SectionFrame.Size = UDim2.new(1, -6, 0, SecLayout.AbsoluteContentSize.Y + 32)
    end)

    return SecContainer
end

local function CreateToggle(parent, text, configKey)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(1, 0, 0, 24)
    ToggleFrame.BackgroundTransparency = 1
    ToggleFrame.Parent = parent

    local Box = Instance.new("TextButton")
    Box.Size = UDim2.new(0, 16, 0, 16)
    Box.Position = UDim2.new(0, 0, 0.5, -8)
    Box.BackgroundColor3 = Config[configKey] and Color3.fromRGB(224, 159, 62) or Color3.fromRGB(20, 22, 26)
    Box.BorderColor3 = Color3.fromRGB(60, 65, 75)
    Box.Text = ""
    Box.Parent = ToggleFrame

    local Label = Instance.new("TextButton")
    Label.Size = UDim2.new(1, -24, 1, 0)
    Label.Position = UDim2.new(0, 24, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(200, 200, 200)
    Label.TextSize = 13
    Label.Font = Enum.Font.SourceSans
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = ToggleFrame

    local function Toggle()
        Config[configKey] = not Config[configKey]
        Box.BackgroundColor3 = Config[configKey] and Color3.fromRGB(224, 159, 62) or Color3.fromRGB(20, 22, 26)
    end

    Box.MouseButton1Click:Connect(Toggle)
    Label.MouseButton1Click:Connect(Toggle)
end

local function CreateSlider(parent, text, min, max, configKey)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Size = UDim2.new(1, 0, 0, 36)
    SliderFrame.BackgroundTransparency = 1
    SliderFrame.Parent = parent

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, 0, 0, 16)
    Label.BackgroundTransparency = 1
    Label.Text = text .. ": " .. tostring(Config[configKey])
    Label.TextColor3 = Color3.fromRGB(200, 200, 200)
    Label.TextSize = 13
    Label.Font = Enum.Font.SourceSans
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = SliderFrame

    local Track = Instance.new("Frame")
    Track.Size = UDim2.new(1, 0, 0, 8)
    Track.Position = UDim2.new(0, 0, 0, 20)
    Track.BackgroundColor3 = Color3.fromRGB(20, 22, 26)
    Track.BorderColor3 = Color3.fromRGB(60, 65, 75)
    Track.Parent = SliderFrame

    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new((Config[configKey] - min) / (max - min), 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(224, 159, 62)
    Fill.BorderSizePixel = 0
    Fill.Parent = Track

    local Dragging = false

    local function Update(input)
        local pos = math.clamp((input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
        local val = math.floor(min + pos * (max - min))
        Config[configKey] = val
        Label.Text = text .. ": " .. tostring(val)
        Fill.Size = UDim2.new(pos, 0, 1, 0)
    end

    Track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            Update(input)
        end
    end)

    Track.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            Update(input)
        end
    end)
end

local AimSec = CreateSection(AimbotPage, "General Aimbot")
CreateToggle(AimSec, "Enabled", "Aimbot")
CreateToggle(AimSec, "WallCheck", "WallCheck")
CreateToggle(AimSec, "Always Active", "Always")
CreateToggle(AimSec, "Draw FOV", "DrawFOV")
CreateSlider(AimSec, "Smoothness", 1, 20, "Smoothness")
CreateSlider(AimSec, "FOV Radius", 30, 300, "FOV")

local EspSec = CreateSection(VisualsPage, "Player ESP")
CreateToggle(EspSec, "Chams", "ESP_Chams")
CreateToggle(EspSec, "Names", "ESP_Names")
CreateToggle(EspSec, "Boxes", "ESP_Box")
CreateToggle(EspSec, "Held Item", "ESP_Item")
CreateToggle(EspSec, "Health Bar", "ESP_Health")
CreateToggle(EspSec, "Distance", "ESP_Distance")

local ViewmodelSec = CreateSection(VisualsPage, "Viewmodel Customizer")
CreateToggle(ViewmodelSec, "Custom Viewmodel", "ViewModel_Enable")
CreateSlider(ViewmodelSec, "Offset X", -50, 50, "ViewModel_X")
CreateSlider(ViewmodelSec, "Offset Y", -50, 50, "ViewModel_Y")
CreateSlider(ViewmodelSec, "Offset Z", -50, 50, "ViewModel_Z")

local MiscSec = CreateSection(MiscPage, "Movement")
CreateToggle(MiscSec, "Speedhack", "Speedhack")
CreateSlider(MiscSec, "Speed Value", 16, 200, "SpeedValue")
CreateToggle(MiscSec, "Infinite Jump", "InfJump")

ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

local FOVFrame = Instance.new("Frame")
FOVFrame.Name = "FOVCircle"
FOVFrame.AnchorPoint = Vector2.new(0.5, 0.5)
FOVFrame.BackgroundTransparency = 1
FOVFrame.BorderColor3 = Color3.fromRGB(224, 159, 62)
FOVFrame.BorderSizePixel = 1
FOVFrame.Visible = false
FOVFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(1, 0)
UICorner.Parent = FOVFrame

local function IsVisible(targetHead)
    local origin = Camera.CFrame.Position
    local direction = targetHead.Position - origin
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character, Camera}
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    raycastParams.IgnoreWater = true

    local result = workspace:Raycast(origin, direction, raycastParams)
    if result then
        return result.Instance:IsDescendantOf(targetHead.Parent)
    end
    return true
end

local function GetClosestPlayer()
    local closest = nil
    local shortestDist = Config.FOV
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") and player.Character:FindFirstChildOfClass("Humanoid") and player.Character.Humanoid.Health > 0 then
            local head = player.Character.Head
            if not Config.WallCheck or IsVisible(head) then
                local pos, onScreen = Camera:WorldToViewportPoint(head.Position)
                if onScreen then
                    local dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                    if dist < shortestDist then
                        shortestDist = dist
                        closest = player
                    end
                end
            end
        end
    end
    return closest
end

local ESP_Folder = Instance.new("Folder")
ESP_Folder.Name = "UTap_ESP"
ESP_Folder.Parent = ScreenGui

local function UpdateESP()
    ESP_Folder:ClearAllChildren()

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChildOfClass("Humanoid") and player.Character.Humanoid.Health > 0 then
            local char = player.Character
            local hum = char:FindFirstChildOfClass("Humanoid")

            if Config.ESP_Chams then
                local highlight = Instance.new("Highlight")
                highlight.Adornee = char
                highlight.FillColor = Color3.fromRGB(224, 159, 62)
                highlight.FillTransparency = 0.5
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                highlight.OutlineTransparency = 0
                highlight.Parent = ESP_Folder
            end

            if Config.ESP_Names or Config.ESP_Box or Config.ESP_Item or Config.ESP_Health or Config.ESP_Distance then
                local billboard = Instance.new("BillboardGui")
                billboard.Adornee = char.HumanoidRootPart
                billboard.Size = UDim2.new(0, 150, 0, 100)
                billboard.StudsOffset = Vector3.new(0, 0, 0)
                billboard.AlwaysOnTop = true
                billboard.Parent = ESP_Folder

                if Config.ESP_Box then
                    local box = Instance.new("Frame")
                    box.Size = UDim2.new(0, 50, 0, 65)
                    box.Position = UDim2.new(0.5, -25, 0.5, -32.5)
                    box.BackgroundTransparency = 1
                    box.BorderColor3 = Color3.fromRGB(224, 159, 62)
                    box.BorderSizePixel = 1
                    box.Parent = billboard
                end

                if Config.ESP_Health then
                    local healthBack = Instance.new("Frame")
                    healthBack.Size = UDim2.new(0, 4, 0, 65)
                    healthBack.Position = UDim2.new(0.5, -32, 0.5, -32.5)
                    healthBack.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
                    healthBack.BorderSizePixel = 0
                    healthBack.Parent = billboard

                    local hpPercent = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
                    local healthBar = Instance.new("Frame")
                    healthBar.Size = UDim2.new(1, 0, hpPercent, 0)
                    healthBar.Position = UDim2.new(0, 0, 1 - hpPercent, 0)
                    healthBar.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
                    healthBar.BorderSizePixel = 0
                    healthBar.Parent = healthBack
                end

                local infoText = ""
                if Config.ESP_Names then
                    infoText = player.Name
                end

                if Config.ESP_Distance and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local dist = math.floor((char.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude)
                    if infoText ~= "" then
                        infoText = infoText .. " [" .. tostring(dist) .. "m]"
                    else
                        infoText = "[" .. tostring(dist) .. "m]"
                    end
                end

                if Config.ESP_Item then
                    local tool = char:FindFirstChildOfClass("Tool")
                    local toolName = tool and tool.Name or "None"
                    if infoText ~= "" then
                        infoText = infoText .. "\n[" .. toolName .. "]"
                    else
                        infoText = "[" .. toolName .. "]"
                    end
                end

                if infoText ~= "" then
                    local label = Instance.new("TextLabel")
                    label.Size = UDim2.new(1, 0, 0, 30)
                    label.Position = UDim2.new(0, 0, 0, -25)
                    label.BackgroundTransparency = 1
                    label.Text = infoText
                    label.TextColor3 = Color3.fromRGB(255, 255, 255)
                    label.TextSize = 12
                    label.Font = Enum.Font.SourceSansBold
                    label.TextStrokeTransparency = 0
                    label.Parent = billboard
                end
            end
        end
    end
end

local function UpdateViewmodel()
    if not Config.ViewModel_Enable then return end
    local offsetX = Config.ViewModel_X / 5
    local offsetY = Config.ViewModel_Y / 5
    local offsetZ = Config.ViewModel_Z / 5

    for _, obj in pairs(Camera:GetChildren()) do
        if obj:IsA("Model") then
            local cf, size = obj:GetBoundingBox()
            if size.Magnitude < 15 and (obj.Name:lower():find("view") or obj.Name:lower():find("arm") or obj.Name:lower():find("weapon") or obj:FindFirstChildOfClass("Humanoid") or obj:FindFirstChildOfClass("AnimationController")) then
                obj:PivotTo(Camera.CFrame * CFrame.new(offsetX, offsetY, offsetZ))
            end
        end
    end

    if LocalPlayer.Character then
        local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
        if tool then
            for _, p in pairs(tool:GetDescendants()) do
                if p:IsA("BasePart") and p.Name == "Handle" then
                    p.CFrame = p.CFrame * CFrame.new(offsetX, offsetY, offsetZ)
                end
            end
        end
    end
end

RunService.RenderStepped:Connect(function()
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    FOVFrame.Position = UDim2.new(0, center.X, 0, center.Y)
    FOVFrame.Size = UDim2.new(0, Config.FOV * 2, 0, Config.FOV * 2)
    FOVFrame.Visible = Config.Aimbot and Config.DrawFOV

    if Config.Aimbot then
        local isAiming = Config.Always or UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) or UserInputService:IsTouchTapInWorld()
        if isAiming then
            local target = GetClosestPlayer()
            if target and target.Character and target.Character:FindFirstChild("Head") then
                local headPos = target.Character.Head.Position
                local camPos = Camera.CFrame.Position
                local targetCFrame = CFrame.new(camPos, headPos)
                Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, 1 / Config.Smoothness)
            end
        end
    end

    if Config.Speedhack and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = Config.SpeedValue
    end

    UpdateESP()
    UpdateViewmodel()
end)

UserInputService.JumpRequest:Connect(function()
    if Config.InfJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

