//
// Created by Artem Kovardin on 26.01.2020.
// Copyright (c) 2020 Artem Kovardin. All rights reserved.
//

import Foundation
import SwiftDate
import AVKit

protocol AlarmServiceDelegate {
    func start()
}

class AlarmService {
    private var played = false
    private let key = "alarm"

    private var player: AVPlayer = {
        let player = AVPlayer()
        return player
    }()

    // MARK: Storage
    func fetch() -> AlarmModel? {
        guard let savedData = UserDefaults.standard.object(forKey: key) as? Data else {
            return AlarmModel(enable: false, date: DateInRegion(region: AlarmModel.moscow))
        }

        guard let alarm = try? JSONDecoder().decode(AlarmModel.self, from: savedData) else {
            return AlarmModel(enable: false, date: DateInRegion(region: AlarmModel.moscow))
        }

        return alarm
    }

    func update(_ model: AlarmModel) {
        let now = DateInRegion(region: AlarmModel.moscow)

        if now > model.date {
            model.date = model.date + 1.days
        }

        print(model.date)

        if let savedData = try? JSONEncoder().encode(model) {
            UserDefaults.standard.set(savedData, forKey: key)
        }
    }

    // MARK: Main logic

    public func run(completion: @escaping (AlarmModel?) -> Void) {
        playTrack(track: "https://4gophers.ru/silent.mp3")

        DispatchQueue.global(qos: .background).async { [weak self] in
            while true {
                sleep(1)
                if self?.check() ?? false {
                    print("start alarm")
                    DispatchQueue.main.async {
                        self?.start()
                        completion(self?.fetch())
                    }

                    sleep(120)
                }
            }
        }
    }

    public func stop(completion: @escaping (AlarmModel?) -> Void) {
        guard let model = fetch() else {
            return
        }

        // при остановке будильника время перестанавливаем на завтра
        // теперь если его включить, то он сработает только на следующий день
        model.enable = false
        model.nextDay()
        update(model)

        played = false
        playTrack(track: "https://4gophers.ru/silent.mp3")

        completion(model)
    }

    // MARK: Helpers

    private func start() {
        playTrack(track: "https://4gophers.ru/outputfile.mp3")
        played = true
    }

    private func check() -> Bool {
        guard let model = fetch() else {
            return false
        }

        if played {
            return false
        }

        return model.isTimeToRing()
    }

    private func playTrack(track url: String?) {
        guard let u = URL(string: url ?? "") else {
            return
        }
        player.replaceCurrentItem(with: AVPlayerItem(url: u))
        player.play()
    }
}