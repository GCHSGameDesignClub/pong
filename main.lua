
function love.load()
    local font = love.graphics.newFont("font.ttf", 32)
    love.graphics.setFont(font)

    paddle     = love.graphics.newImage("paddle.png")
    seperator  = love.graphics.newImage("seperator.png")

    scrWidth   = love.graphics.getWidth()
    scrHeight  = love.graphics.getHeight()

    gameState = 1

    ball = {}
    ball.img = love.graphics.newImage("ball.png")
    ball.x = scrWidth / 2
    ball.y = scrHeight / 2
    ball.vel = {} --the ball's velocity
    ball.vel.x = -4 --the x component of the velocity
    ball.vel.y = -4

    mvSpd = 5
    delay = 100 --amount of time to delay between rounds
    curDelay = delay

    y1 = scrHeight / 2
    y2 = scrHeight / 2
    p1score = 0
    p2score = 0
end

function resetBall(player)
    if player == 1 then
        p1score = p1score + 1
        ball.vel.x = 4
    elseif player == 2 then
        p2score = p2score + 1
        ball.vel.x = -4
    end
    
    curDelay = delay
    ball.x = scrWidth / 2
    ball.y = scrHeight / 2
    ball.vel.y = 4
    mvSpd = 5
end

function incBallVel(vel)
    if vel == "x" then
        if ball.vel.x < 0 then
            ball.vel.x = ball.vel.x - 1
        else
            ball.vel.x = ball.vel.x + 1
        end
    elseif vel == "y" then
        if ball.vel.y < 0 then
            ball.vel.y = ball.vel.y - 1
        else
            ball.vel.y = ball.vel.y + 1
        end
    end
    mvSpd = mvSpd + 0.5
end

function love.keypressed(key)
    if key == "1" then
        gameState = 1
    elseif key == "2" then
        gameState = 2
    elseif key == "3" then
        gameState = 3
    end
end

function love.update()
    if love.keyboard.isDown("w") and y1 > 1 then
        if gameState == 1 or gameState == 3 or (gameState == 2 and ball.x > scrWidth/4) then
            y1 = y1 - mvSpd
        end
    end
    
    if love.keyboard.isDown("s") and y1 < scrHeight - paddle:getHeight() then
        if gameState == 1 or gameState == 3 or (gameState == 2 and ball.x > scrWidth/4) then
            y1 = y1 + mvSpd
        end
    end
    
    if love.keyboard.isDown("up") and y2 > 1 then
        if gameState == 1 or gameState == 3 or (gameState == 2 and ball.x < scrWidth/4*3) then
            y2 = y2 - mvSpd
        end
    end
    
    if love.keyboard.isDown("down") and y2 < scrHeight - paddle:getHeight() then
        if gameState == 1 or gameState == 3 or (gameState == 2 and ball.x < scrWidth/4*3) then
            y2 = y2 + mvSpd
        end
    end

    if curDelay == 0 then
        ball.x = ball.x + ball.vel.x
        ball.y = ball.y + ball.vel.y
    
        --collision check with p1's paddle
        if ball.x >= 10 and ball.x <= 10 + paddle:getWidth() and ball.y >= y1 and ball.y <= y1 + paddle:getHeight() then
            ball.vel.x = -ball.vel.x
            if gameState == 3 then incBallVel("x") end
        elseif ball.x >= scrWidth - 10 - paddle:getWidth() and ball.x <= scrWidth - 10 and ball.y >= y2 and ball.y <= y2 + paddle:getHeight() then
            ball.vel.x = -ball.vel.x
            if gameState == 3 then incBallVel("x") end
        end

        if ball.x <= 0 then --p1 loses
            resetBall(2)
        elseif ball.x >= scrWidth then --p2 loses
            resetBall(1)
        end

        if ball.y <= 0 or ball.y >= scrHeight then
            ball.vel.y = -ball.vel.y
            
            if gameState == 3 then
                --incBallVel("y")
            end
        end
    else
        curDelay = curDelay - 1
    end
end

function love.draw()
    if gameState == 2 then
        love.graphics.draw(seperator, scrWidth/4, 0)
        love.graphics.draw(seperator, scrWidth/4*3, 0)
    else
        love.graphics.draw(seperator, scrWidth/2, 0)
    end

    love.graphics.print(p1score, 40, 15)
    love.graphics.print(p2score, scrWidth - 75, 15)

    love.graphics.print("Gamemode " .. gameState, 25, scrHeight-30)

    love.graphics.draw(paddle, 10, y1)
    love.graphics.draw(paddle, scrWidth - 10 - paddle:getWidth(), y2)

    love.graphics.draw(ball.img, ball.x, ball.y)
end
