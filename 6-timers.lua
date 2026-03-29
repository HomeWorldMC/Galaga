function after(duration,callback)
	add(timers, {t=0, d=duration, cb=callback})
end

function cycle(rotations,spd,callback)
	add(cycletimers, {ang=0, r=rotations, s=spd, cb=callback})
end

function move(set, startp, endp, obj,callback)
	if movetimers[set]==nil then
		add(movetimers,{})
	end
	
	add(movetimers[set],{sx=startp.x, sy=startp.y, ex=endp.x, ey=endp.y, obj=obj, cb=callback})
end

-- { { {},{},{} }, { {},{},{} }}

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
			ct.cb(ct.ang,ct.r)
			del(cycletimers, ct)
			cycleflag=false
		else
			ct.cb(ct.ang,ct.r)
		end			
	end
end

function update_movetimers(set)
	local dist
	local dx
	local dy
	local vx
	local vy
	local disttonext

	local mt

	--queue_prt("#movetimers:"..#movetimers..",set:"..set,5,80,textcol)
	
	if #movetimers>0 then
		if movetimers[set]~=nil then
			mt=movetimers[set][1]		

			if mt~=nil and not cycleflag do
				dx=mt.ex-mt.sx  -- delta x move
				dy=mt.ey-mt.sy  -- delta y move
				
				dist = sqrt(dx*dx + dy*dy) -- delta move

				vx=dx/dist * 0.55 -- velocity x comp
				vy=dy/dist * 0.55 -- velocity y comp
				
				mt.sx+=vx  -- Move object in x
				mt.sy+=vy  -- Move object in y
				
				disttonext = (abs(mt.sx-mt.ex)+abs(mt.sy-mt.ey))

				if disttonext < 1 then
					mt.obj.x=mt.ex
					mt.obj.y=mt.ey
					del(movetimers[set],mt)
					if #movetimers[set]==0 then
						del(movetimers,movetimers[set])
						if mt.cb~=nil then
							mt.cb()
						end
					end
				else
					mt.obj.x=mt.sx
					mt.obj.y=mt.sy
				end
			end
		end
	end
end