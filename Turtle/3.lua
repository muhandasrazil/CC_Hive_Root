term.clear()
term.setCursorPos(1,1)
math.randomseed(os.time() + math.floor(1000 * os.clock()))
function randomCoord()
    return math.random(-50, 50)
end
coordA = {x = randomCoord(), y = randomCoord(), z = randomCoord()}
coordB = {x = randomCoord(), y = randomCoord(), z = randomCoord()}
print("A: ".."{".."x = "..coordA.x..", y = "..coordA.y..", z = "..coordA.z.."}")
print("B: ".."{".."x = "..coordB.x..", y = "..coordB.y..", z = "..coordB.z.."}")
output = move.d_math(coordA,coordB)
print()
print()
print("O: ".."{".."x = "..output.x..", y = "..output.y..", z = "..output.z.."}")