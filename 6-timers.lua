function after(duration,callback)
		add(timers, {t=0, d=duration, cb=callback})
	end

	function cycle(rotations,spd,callback)
		add(cycletimers, {ang=0, r=rotations, s=spd, cb=callback})
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
				player.f=16
			else
				ct.cb(ct.ang,ct.r)
			end			
		end
	end