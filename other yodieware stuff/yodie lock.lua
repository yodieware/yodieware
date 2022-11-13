-- https://www.roblox.com/games/2788229376/Da-Hood --
getgenv().Silent = {
    Key = "Q",
    Prediction = 0.1307,
    Airshot = false,
    Part = "LowerTorso",
    Radius = 120
}
local Image = {
    Enabled = true,
    Url = "https://i.pinimg.com/originals/2a/41/2f/2a412f08430c15489581b6d1f067de5b.jpg"
}
local Dot = {
    Enabled = false,
    Color = Color3.fromRGB(255,255,255),
Transparency = 1,
    Thickness = 2
}
local CC = game:GetService("Workspace").CurrentCamera
local LocalMouse = game.Players.LocalPlayer:GetMouse()
local Locking = false
local cc = game:GetService("Workspace").CurrentCamera
local gs = game:GetService("GuiService")
local ggi = gs.GetGuiInset
local lp = game:GetService("Players").LocalPlayer
local mouse = lp:GetMouse()

local Tracer = Drawing.new("Image")
Tracer.Data = game:HttpGet(Image.Url)
Tracer.Size = Vector2.new(79, 79)
 local Circle = Drawing.new("Circle")
    Circle.Color = Dot.Color
    Circle.Thickness = Dot.Thickness
    Circle.Radius = 5.5 
    Circle.Visible = Dot.Enabled
    Circle.Filled = true
    Circle.Transparency = Dot.Transparency
function x(tx)
    game.StarterGui:SetCore(
        "SendNotification",
        {
            Title = "Yodie Lock",
            Text = tx,
            Duration = 3.6
        }
    )
end

x("Loaded")

if getgenv().flashyes == true then
    x("Already Loaded")
    return
end
getgenv().flashyes = true


game:GetService("UserInputService").InputBegan:Connect(
    function(keygo, ok)
        if (not ok) then
            if (keygo.KeyCode.Name == getgenv().Silent.Key) then
                Locking = not Locking
                if Locking then
                    Plr = getClosestPlayerToCursor()
                     pcall(function()
                    x(Plr.Character.Humanoid.DisplayName)
                    end)
                elseif not Locking then
                    if Plr then
                        Plr = nil
                        x("Unlocked")
                    end
                end
            end
        end
    end
)
function getClosestPlayerToCursor()
    local closestPlayer
    local shortestDistance = getgenv().Silent.Radius

    for i, v in pairs(game.Players:GetPlayers()) do
        if
            v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("Humanoid") and
                v.Character.Humanoid.Health ~= 0 and
                v.Character:FindFirstChild("LowerTorso")
         then
            local pos = CC:WorldToViewportPoint(v.Character.PrimaryPart.Position)
            local magnitude = (Vector2.new(pos.X, pos.Y) - Vector2.new(LocalMouse.X, LocalMouse.Y)).magnitude
            if magnitude < shortestDistance then
                closestPlayer = v
                shortestDistance = magnitude
            end
        end
    end
    return closestPlayer
end

local rawmetatable = getrawmetatable(game)
local old = rawmetatable.__namecall
setreadonly(rawmetatable, false)
rawmetatable.__namecall =
    newcclosure(
    function(...)
        local args = {...}
        if Plr ~= nil and getnamecallmethod() == "FireServer" and args[2] == "UpdateMousePos" then
            args[3] =
                Plr.Character[getgenv().Silent.Part].Position +
                (Plr.Character[getgenv().Silent.Part].Velocity * Silent.Prediction)
            return old(unpack(args))
        end
        return old(...)
    end
)

game:GetService("RunService").RenderStepped:connect(
    function()
        if getgenv().Silent.Airshot == true then
            if
                Plr ~= nil and Plr.Character.Humanoid.Jump == true and
                    Plr.Character.Humanoid.FloorMaterial == Enum.Material.Air
             then
                getgenv().Silent.Part = "RightFoot"
            else
                Plr.Character:WaitForChild("Humanoid").StateChanged:Connect(
                    function(old, new)
                        if new == Enum.HumanoidStateType.Freefall then
                            getgenv().Silent.Part = "RightFoot"
                        else
                            getgenv().Silent.Part = "LowerTorso"
                        end
                    end
                )
            end
        end

        if Image.Enabled == true and Plr ~= nil  then
            local Vector, OnScreen = cc:worldToViewportPoint(Plr.Character[getgenv().Silent.Part].Position)
            Tracer.Visible = true
            Tracer.Position = Vector2.new(Vector.X, Vector.Y)
        else
            Tracer.Visible = false
        end
  
  if Dot.Enabled == true and Plr ~= nil  then
                  local Vector, OnScreen = cc:worldToViewportPoint(Plr.Character[getgenv().Silent.Part].Position)
            Circle.Visible = true
            Circle.Position = Vector2.new(Vector.X, Vector.Y)
        else
            Circle.Visible = false
        end
    end)
