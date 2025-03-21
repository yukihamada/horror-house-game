-- EnemyAI.lua
-- 敵のAI制御スクリプト

local PathfindingService = game:GetService("PathfindingService")
local enemy = script.Parent
local humanoid = enemy:WaitForChild("Humanoid")
local rootPart = enemy:WaitForChild("HumanoidRootPart")

-- AI設定
local settings = {
	detectionRange = 20, -- プレイヤー検知範囲
	patrolSpeed = 8, -- 巡回速度
	chaseSpeed = 16, -- 追跡速度
	state = "Patrol", -- 初期状態（Patrol, Chase, Search）
	lastSeenPosition = nil, -- 最後にプレイヤーを見た位置
	currentTarget = nil -- 現在のターゲット
}

-- パスファインディング設定
local path = PathfindingService:CreatePath({
	AgentRadius = 2,
	AgentHeight = 5,
	AgentCanJump = true
})

-- プレイヤー検知関数
local function detectPlayers()
	for _, player in pairs(game.Players:GetPlayers()) do
		if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			local playerRoot = player.Character.HumanoidRootPart
			local distance = (playerRoot.Position - rootPart.Position).Magnitude
			
			if distance <= settings.detectionRange then
				-- 視線チェック（壁越しに見えないようにする）
				local ray = Ray.new(rootPart.Position, playerRoot.Position - rootPart.Position)
				local hit, hitPosition = workspace:FindPartOnRay(ray, enemy)
				
				if hit and hit:IsDescendantOf(player.Character) then
					settings.state = "Chase"
					settings.currentTarget = player
					settings.lastSeenPosition = playerRoot.Position
					humanoid.WalkSpeed = settings.chaseSpeed
					return true
				end
			end
		end
	end
	return false
end

-- 巡回関数
local function patrol()
	-- ランダムな位置に移動
	local randomPosition = rootPart.Position + Vector3.new(math.random(-20, 20), 0, math.random(-20, 20))
	humanoid:MoveTo(randomPosition)
end

-- 追跡関数
local function chase()
	if settings.currentTarget and settings.currentTarget.Character then
		local targetRoot = settings.currentTarget.Character:FindFirstChild("HumanoidRootPart")
		if targetRoot then
			-- パスを計算
			path:ComputeAsync(rootPart.Position, targetRoot.Position)
			
			if path.Status == Enum.PathStatus.Success then
				-- パスに沿って移動
				local waypoints = path:GetWaypoints()
				for i, waypoint in ipairs(waypoints) do
					humanoid:MoveTo(waypoint.Position)
					-- ウェイポイントに到着するまで待機
					local reachedWaypoint = humanoid.MoveToFinished:Wait()
					
					-- 移動中にプレイヤーを見失ったら探索状態に移行
					if not detectPlayers() and i == #waypoints then
						settings.state = "Search"
						break
					end
				end
			end
		end
	end
end

-- 探索関数
local function search()
	if settings.lastSeenPosition then
		-- 最後にプレイヤーを見た位置に移動
		humanoid:MoveTo(settings.lastSeenPosition)
		humanoid.MoveToFinished:Wait()
		
		-- 周囲を探索
		for i = 1, 4 do
			local angle = math.rad(i * 90)
			local searchPos = settings.lastSeenPosition + Vector3.new(math.cos(angle) * 10, 0, math.sin(angle) * 10)
			humanoid:MoveTo(searchPos)
			humanoid.MoveToFinished:Wait()
			
			-- 探索中にプレイヤーを発見したら追跡状態に戻る
			if detectPlayers() then
				return
			end
		end
		
		-- プレイヤーが見つからなければ巡回状態に戻る
		settings.state = "Patrol"
	else
		settings.state = "Patrol"
	end
end

-- メインループ
while wait(0.5) do
	if settings.state == "Patrol" then
		humanoid.WalkSpeed = settings.patrolSpeed
		detectPlayers() -- プレイヤー検知
		patrol() -- 巡回
	elseif settings.state == "Chase" then
		chase() -- 追跡
	elseif settings.state == "Search" then
		humanoid.WalkSpeed = settings.patrolSpeed
		search() -- 探索
	end
end