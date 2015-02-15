fill = 'right'
suck = 'left'
turtle.select(1)

--Find the me_interface
while peripheral.getType('front') ~= 'me_interface' do
    turtle.turnRight()
end

function back (dir)
  if dir == "Left" then
    return "Right"
  else
    return "Left"
  end
end

function breakTank (dir)
  turtle["turn"..dir]()
  turtle.dig()
  turtle["turn"..back(dir)]()
end

function placeDrum (dir)
  print('Turning '..dir..' to place')
  turtle["turn"..dir]()
  turtle.select(1)
  turtle.place()
  turtle["turn"..back(dir)]()
end

function get(from)
  didSuck = turtle["suck"..from](1)
  if turtle.getItemCount(1) > 1 then
    turtle.drop(turtle.getItemCount(1)-1)
  end
  return didSuck
end

function replace (tankDir, replacementDir)
  breakTank(tankDir)
  turtle.drop()
  didSuck = get(replacementDir)
  if didSuck then
    placeDrum(tankDir)
  end
end

loopCount = 1
while loopCount < 20 do 
  ft = peripheral.wrap(fill)
  st = peripheral.wrap(suck)

  --Loop for Input
  if(ft) then
    if(ft.getTankInfo(fill)[1]['amount']) then
      if(ft.getTankInfo(fill)[1]['amount'] >= ft.getTankInfo(fill)[1]['capacity']) then
        print('Full Tank!')
        replace("Right", '')
      end
    end      
  else
    print('No Tank to Fill!')
    didSuck = get('')
    if didSuck then
        placeDrum("Right")
    end
  end

  --Loop for Output
  if(st) then
    if(st.getTankInfo(suck)[1]['amount'] == nil ) then
      print('Empty Tank!')
      replace('Left', 'Up')
    end      
  else
    print('No Tank to Empty!')
    didSuck = get("Up")
    if didSuck then
        placeDrum('Left')
    end
  end
  os.sleep(2.5)
  loopCount = loopCount + 1
end

os.reboot()