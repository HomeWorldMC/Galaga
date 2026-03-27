function after(duration,callback)
	add(timers, {t=0, d=duration, cb=callback})
end

function cycle(rotations,spd,callback)
	add(cycletimers, {ang=0, r=rotations, s=spd, cb=callback})
end

function move(startp, endp)
	add(movetimers,{sx=startp.x, sy=startp.y, ex=endp.x, ey=endp.y})
end

function update_timers(dt)
	for t in all(timers) do
		t.t += dt
		if t.t >= t.d then
		t.cb()
		del(timers, t)
		end
	end
end

function update_cycletimers()
	for ct in all(cycletimers) do
		ct.ang+=ct.s
		if ct.ang>1 then
			ct.ang=0
			ct.r-=1
		end
		if ct.r<1 then
			del(cycletimers, ct)
			player.f=23
		else
			ct.cb(ct.ang,ct.r)
		end			
	end
end

function update_movetimers()
	local dist
	local dx
	local dy
	local vx
	local vy
	local disttonext

	local mt=movetimers[1]

	if mt~=nil do
		dx=mt.ex-mt.sx  -- delta x move
		dy=mt.ey-mt.sy  -- delta y move
		
		dist = sqrt(dx*dx + dy*dy) -- delta move

		vx=dx/dist * 0.35 -- velocity x comp
		vy=dy/dist * 0.35 -- velocity y comp
		
		mt.sx+=vx  -- Move object in x
		mt.sy+=vy  -- Move object in y
		
		disttonext = (abs(mt.sx-mt.ex)+abs(mt.sy-mt.ey)) 

		if disttonext < 1 then
			player.x=mt.ex
			player.y=mt.ey
			del(movetimers,mt)
		else
			player.x=mt.sx
			player.y=mt.sy
		end
	end
end