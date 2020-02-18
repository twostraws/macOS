//
//  ViewController.swift
//  Project9
//
//  Created by TwoStraws on 21/10/2016.
//  Copyright © 2016 Paul Hudson. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
	override func viewDidLoad() {
		super.viewDidLoad()

		runBackgroundCode1()
		//runBackgroundCode2()
		//runBackgroundCode3()
		//runBackgroundCode4()
		//runSynchronousCode()
		//runDelayedCode()
		//runMultiprocessing1()
		//runMultiprocessing2(useGCD: false)
		//runMultiprocessing2(useGCD: true)
	}

	@objc func log(message: String) {
		print("Printing message: \(message)")
	}

	func runBackgroundCode1() {
		performSelector(inBackground: #selector(log), with: "Hello world 1")
		performSelector(onMainThread: #selector(log), with: "Hello world 2", waitUntilDone: false)
		log(message: "Hello world 3")
	}

	func runBackgroundCode2() {
		DispatchQueue.global().async { [unowned self] in
			self.log(message: "On background thread")

			DispatchQueue.main.async {
				// we don't need  [unowned self] in here
				self.log(message: "On main thread")
			}
		}
	}

	func runBackgroundCode3() {
		DispatchQueue.global().async {
			guard let url = URL(string: "https://www.apple.com") else { return }
			guard let str = try? String(contentsOf: url) else { return }
			print(str)
		}
	}

	func runBackgroundCode4() {
		DispatchQueue.global(qos: .userInteractive).async { [unowned self] in
			self.log(message: "This is high priority")
		}
	}

	func runSynchronousCode() {
		DispatchQueue.global().async {
			print("Background thread 1")
		}

		print("Main thread 1")


		DispatchQueue.global().sync {
			print("Background thread 2")
		}

		print("Main thread 2")
	}

	func runDelayedCode() {
		perform(#selector(log), with: "Hello world 1", afterDelay: 1)

		DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [unowned self] in
			self.log(message: "Hello world 2")
		}

		DispatchQueue.global().asyncAfter(deadline: .now() + 1) { [unowned self] in
			self.log(message: "Hello world 3")
		}
	}

	func runMultiprocessing1() {
		DispatchQueue.concurrentPerform(iterations: 10) {
			print($0)
		}
	}

	func runMultiprocessing2(useGCD: Bool) {
		func fibonacci(of num: Int) -> Int {
			if num < 2 {
				return num
			} else {
				return fibonacci(of: num - 1) + fibonacci(of: num - 2)
			}
		}

		var array = Array(0 ..< 42)
		let start = CFAbsoluteTimeGetCurrent()

		if useGCD {
			DispatchQueue.concurrentPerform(iterations: array.count) {
				array[$0] = fibonacci(of: $0)
			}
		} else {
			for i in 0 ..< array.count {
				array[i] = fibonacci(of: array[i])
			}
		}

		let end = CFAbsoluteTimeGetCurrent() - start
		print("Took \(end) seconds")
	}
}
