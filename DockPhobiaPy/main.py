from pynput.mouse import Controller
import subprocess
import AppKit
import time
from memory_profiler import profile

mouse = Controller()

def getDockSide():
	script = "defaults read com.apple.Dock orientation"
	result = subprocess.run(["bash", "-c", script], capture_output=True,text=True)

	formattedResult = result.stdout.strip()
	return formattedResult


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

def getDockHeight():
	screen = AppKit.NSScreen.mainScreen()

	fullHeight = screen.frame().size.height
	visibleHeight = screen.visibleFrame().size.height

	dockHeight = fullHeight - visibleHeight
	percentage = (dockHeight / fullHeight)
	return percentage

print(getScreenSize())
# moveDock("bottom")
dockSide = getDockSide()
startedOutAt = dockSide

print()
def calcDockFromBottom():
	# screenSize = getScreenSize()
	dockHeight = getDockHeight()
	return screenSize[1]-(screenSize[1]*dockHeight)

dockFromBottom = calcDockFromBottom()
print(dockFromBottom)

def calcDockFromLeft():
	# screenSize = getScreenSize()
	dockHeight = getDockHeight()
	return screenSize[1]*dockHeight

dockFromLeft = calcDockFromLeft()
print(dockFromLeft)

def calcDockFromRight():
	# screenSize = getScreenSize()
	dockHeight = getDockHeight()
	return screenSize[0]-(screenSize[1]*dockHeight)
dockFromRight = calcDockFromRight()
print(dockFromRight)

@profile
def run_loop():
	global dockSide, dockFromBottom, dockFromLeft, dockFromRight, startedOutAt

	while True:
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
				# neverbeenside = False
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
		if startedOutAt == "":
			continue
		elif startedOutAt == "bottom" and dockSide != "bottom":
			# started at bottom, dock is at side, recalc the actuation distance from sides
			dockFromLeft = calcDockFromLeft()
			dockFromRight = calcDockFromRight()
			startedOutAt = ""
		elif startedOutAt == "right" or startedOutAt == "left" and dockSide == "bottom":
			#started on the side, now at bottom recalc the distance from bottom
			dockFromBottom = calcDockFromBottom()
			startedOutAt = ""
		time.sleep(0.001)

run_loop()
