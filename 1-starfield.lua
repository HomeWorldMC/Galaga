function dostarfield()
	for s in all(stars) do
		pset(s.x,s.y,s.col)
	end
	
	if gamephase>=1 then
		blink+=0.35
		if blink>10.95 then blink=0 end
		if blink>=0 and blink<6 then
			print("1up ",9,2,8)
		end
		print(player.score,25,2,7)
	end
	animatestars()
end

function animatestars()
	for s in all(stars) do
		if gamephase==1 then
			s.y+=(s.spd/4)*-1
			if s.y<1 then
				s.y = 126
				s.x=rnd(126)+1
			end
		else
			s.y+=s.spd
			if s.y>127 then
				s.y = 1
				s.x=rnd(126)+1
			end
		end
	end
end

function setstageicons()
	local sx=127
	local sy=118
	local xoffset={5,5,8,8,8,8}
		
	for sn=1, #numshields do
		for i=1, numshields[sn] do
			sx-=xoffset[sn]
			spr(stageiconsprites[sn],sx,sy)
		end
	end
end

function setlivesicons()
	local sx=2
	for i=1,player.lives do
		spr(1,sx,118)
		sx+=8
	end

end

function getshieldnumbers() --4
	local rmd=stage
	
	local fives=0
	local tens=0
	local twenties=0
	local thirties=0
	local fifties=0
	
	if rmd >= 50 then 
		fifties=(rmd-(rmd%50))/50
		rmd=rmd%50
	end
	
	if rmd >= 30 then
		thirties=(rmd-(rmd%30))/30
		rmd=rmd%30
	end
	
	if rmd >= 20 then
		twenties=(rmd-(rmd%20))/20
		rmd=rmd%20
	end
	
	if rmd >= 10 then
		tens=(rmd-(rmd%10))/10
		rmd=rmd%10
	end
	
	if rmd >= 5 then
		fives=(rmd-(rmd%5))/5
		rmd=rmd%5
	end
	
	numshields={rmd,fives,tens,twenties,thirties,fifties}
	--local stn=numshields[1] .. "," .. numshields[2] .. "," .. numshields[3] .. "," .. numshields[4] .. "," .. numshields[5] .. "," .. numshields[6]
	--print(stn,10,74)
end