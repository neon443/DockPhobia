from pynput.mouse import Button, Controller
import subprocess
import time
import AppKit
mouse = Controller()
#while True:


def getDockSide():
	script = "defaults read com.apple.Dock orientation"
	result = subprocess.run(["bash", "-c", script], capture_output=True,text=True)
	if result.stdout != None:
		print(result.stdout)
dockSide = getDockSide()

def moveDock(to):
	script = f"""
		tell application "System Events"
			tell dock preferences
				set screen edge to {to}
			end tell
		end tell
	"""
	result = subprocess.run(["osascript", "-e", script], capture_output=True, text=True)
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
		print("sdfioewiofj ", resultArr)
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
	print(dockHeight)
	percentage = (dockHeight / fullHeight) * 100
	return percentage

moveDock("left")
time.sleep(0.1)
moveDock("bottom")
print("mousepos", mouse.position)

screenSize = getScreenSize()
print(screenSize)
while True:
	if mouse.position[1] > 2600:
		moveDock("left")
		time.sleep(0.1)
