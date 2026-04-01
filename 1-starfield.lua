function dostarfield()
	for s in all(stars) do
		pset(s.x,s.y,s.col)
	end	
	if gamephase>=2 then
		blink+=0.35
		if blink>10.95 then blink=0 end
		if blink>=0 and blink<6 then
			print("1up ",9,2,8)
		end
		print(player.score,25,2,7)
	end	
end

function animatestars()
	for st in all(stars) do
		if gamephase<=1 then
			st.y-=st.spd/4
			if st.y<1 then
				st.y = 126
				st.x=rnd(126)+1
			end
		else
			st.y+=st.spd
			if st.y>127 then
				st.y = 1
				st.x=rnd(126)+1
			end
		end
	end
end

function setstageicons()
	local sx=127
	for sn=1, #numshields do
		for i=1, numshields[sn] do
			sx-=xoffset[sn]
			queue_spr(stageiconsprites[sn],sx,118,1,1,false,false)
		end
	end
end

function setlivesicons()
	local sx=2
	for i=1,player.lives do
		queue_spr(30,sx,118,1,1,false,false)
		sx+=6
	end
end

function getshieldnumbers()
	local r=stage
	local d={50,30,20,10,5}
	local n={0,0,0,0,0,0}

	for i=1,5 do
	n[7-i]=flr(r/d[i])
	r%=d[i]
	end

	n[1]=r
	numshields=n
end