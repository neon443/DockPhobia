from pynput.mouse import Button, Controller
import subprocess
import time
import AppKit
import pdb

mouse = Controller()
#while True:


def getDockSide():
	# pdb.set_trace()
	script = "defaults read com.apple.Dock orientation"
	result = subprocess.run(["bash", "-c", script], capture_output=True,text=True)
	return result.stdout

def moveDock(to):
	script = f"""
		tell application "System Events"
			tell dock preferences
				set screen edge to {to}
			end tell
		end tell
	"""
	result = subprocess.run(["osascript", "-e", script], capture_output=True, text=True)
	return result.stdout
	# print(result.stdout)

def getScreenSize():
	script = """
	tell application "Finder"
		get bounds of window of desktop
	end tell
	"""
	result = subprocess.run(["osascript", "-e", script], capture_output=True, text=True)

	try:
		resultArr = [int(num) for num in result.stdout.strip().split(", ")]
		resultArr = resultArr[2:]
		return resultArr
	except ValueError:
		print("error parsing screensize")
		return []

screenSize = getScreenSize()
print(f"Screen size: {screenSize}")

def getDockHeight():
	screen = AppKit.NSScreen.mainScreen()

	fullHeight = screen.frame().size.height
	visibleHeight = screen.visibleFrame().size.height

	dockHeight = fullHeight - visibleHeight
	percentage = (dockHeight / fullHeight)
	return percentage+0.03 # increase size

screenSize = getScreenSize()

print(getDockHeight())
print(getScreenSize())
moveDock("bottom")
dockSide = "bottom"
dockHeight = getDockHeight()

print()
dockFromBottom = screenSize[1]-(screenSize[1]*dockHeight)
print(dockFromBottom)

print()
dockFromLeft = screenSize[1]*dockHeight
print(dockFromLeft)

print()
dockFromRight = screenSize[1]*dockHeight
dockFromRight = screenSize[0]-(screenSize[1]*dockHeight)
print(dockFromRight)






while True:
	# print(dockSide)
	if dockSide == "bottom":
		if mouse.position[1] > dockFromBottom:
			if mouse.position[0] < screenSize[0]/2:
				moveDock("right")
				dockSide = "right"
				#if mouse is at bottom and is on the left
			else:
				moveDock("left")
				dockSide = "left"
				#mouse is at bottom but on the right of screen

	elif dockSide == "left":
		if mouse.position[0] < dockFromLeft:
			if mouse.position[1] < screenSize[1]/2:
				moveDock("bottom")
				dockSide = "bottom"
				#mouse is at left but top half
			else:
				moveDock("right")
				dockSide = "right"
				#mouse is at left but bottom half

	elif dockSide == "right":
		if mouse.position[0] > dockFromRight:
			if mouse.position[1] < screenSize[1]/2:
				moveDock("bottom")
				dockSide = "bottom"
				#mouse is at right but top half
			else:
				moveDock("left")
				dockSide = "left"
				#mouse is at right but bottom half

	time.sleep(0.01)
