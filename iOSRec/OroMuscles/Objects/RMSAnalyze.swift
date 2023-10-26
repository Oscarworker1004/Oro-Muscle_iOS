//
//  RMSAnalyze.swift
//  OroMuscles
//
//  Created by Elizabeth Evans on 8/29/23.
//

import Foundation

//TODO READ 10.4) This is the file to help with getting the raw data to be intensity and work capacity
class RMSAnalyze : NSObject {
    var m_floorOff: Double = 20.0
    var m_peakMin: Int = 50
    var m_delay: Int = 2
    var m_floorData: Double = 0.0
    var m_ptr: Int = 0
    var m_freq: Double = 500.0
    var m_local: Double = 0.0
    var m_lastMax: Double = 0.0
    var m_currAUC: Double = 0.0
    var m_currRMS: Double = 0.0
    var m_floor: Double = 0.0
    var m_nullCount: Int = 0
    var m_nullCountDev: Int = 0
    var m_floorRate: Double = 0.001
    var m_bufRMS: [Double] = []
    var m_bufEMG: [Double] = []
    var m_have: Int = 0
    var m_size: Int = 0
    private var m_lastPeak : Int = 0
    
    override init() {
        m_bufRMS = Array(repeating: 0.0, count: Int(m_freq * 8 + 0.5))
        m_bufEMG = Array(repeating: 0.0, count: Int(m_freq * 8 + 0.5))
        m_size = m_bufRMS.count
        m_ptr = 0
        m_freq = 500.0
        m_local = 0.0
        m_lastMax = 0.0
        m_currAUC = 0.0
        m_currRMS = 0.0
        m_have = 0
        m_bufRMS = Array(repeating: 0.0, count: Int(m_freq * 8 + 0.5))
        m_bufEMG = Array(repeating: 0.0, count: Int(m_freq * 8 + 0.5))
        m_size = m_bufRMS.count
        m_floor = 0.0
        m_floorData = 1.0
        m_floorRate = 0.001
        m_nullCount = 0
        m_nullCountDev = 0
    }

    func setFloorOff(_ val: Int) {
        m_floorOff = Double(val) / 10.0
    }

    func setPeakMinDist(_ val: Int) {
        m_peakMin = val
    }

    func nullAndCrop(emg_out: inout [Double], rms_out: inout [Double], emg_in: [Double], rms_in: [Double], fromIdx: Int) {
        let win = 150
        let max = 5000.0

        emg_out = Array(emg_in[fromIdx...])
        rms_out = Array(rms_in[fromIdx...])

        for i in 0..<emg_out.count {
            if emg_out[i] > max || emg_out[i] < -max {
                for j in (i - win)..<min(i + win, rms_out.count) {
                    if j > 0 && j < rms_out.count {
                        rms_out[j] = 0.0
                    }
                }
            }
        }
    }

    func setDelay(_ d: Int) {
        m_delay = d
    }

    func reset() {
        m_ptr = 0
        m_freq = 500.0
        m_local = 0.0
        m_lastMax = 0.0
        m_currAUC = 0.0
        m_currRMS = 0.0
        m_have = 0
        m_bufRMS = Array(repeating: 0.0, count: Int(m_freq * 8 + 0.5))
        m_bufEMG = Array(repeating: 0.0, count: Int(m_freq * 8 + 0.5))
        m_size = m_bufRMS.count
        m_floor = 0.0
        m_floorData = 1.0
        m_floorRate = 0.001
        m_nullCount = 0
        m_nullCountDev = 0
    }

    func isSilence() -> Bool {
        return m_nullCount > 400
    }

    func getAUC() -> Double {
        return m_currAUC
    }

    func getRMS() -> Double {
        return m_currRMS
    }

    func getFloor() -> Double {
        return m_floor
    }

    func feed(rms: Double, emg: Double) -> Bool {
        pushBack(rms: rms, emg: emg)

        m_floorData += 0.001
        m_floor = m_floor * (1.0 - m_floorRate / m_floorData) + rms * m_floorRate / m_floorData
        m_lastMax *= (1.0 - m_floorRate)

        if rms < 15.0 {
            m_nullCount += 1
        } else {
            m_nullCount = 0
        }

        if m_have > 3 {
            let d = getRMS(index: m_size - 2)
            if d > getRMS(index: m_size - 3) && d >= getRMS(index: m_size - 1) {
                if d > m_floor + m_floorOff && d > m_lastMax * 0.6 {
                    m_local = d
                    if d > m_lastMax {
                        m_lastMax = d
                    }
                }
            }
        }

        m_lastPeak += 1
        let check = 100
        if m_have > m_delay + 1 + 2 * check {
            let d = getRMS(index: m_size - m_delay)
            if (d > getRMS(index: m_size - m_delay - 1) && d >= getRMS(index: m_size - m_delay + 1)) &&
                (d > getRMS(index: m_size - m_delay - check) && d >= getRMS(index: m_size - m_delay + check)) {
                if d > m_floor + m_floorOff && d > m_lastMax * 0.4 && m_lastPeak > m_peakMin {
                    computeAUC(low: d * 0.2)
                    m_local = d
                    m_lastPeak = 0
                    return true
                }
            }
        }

        return false
    }

    private func computeAUC(low: Double) {
        m_currAUC = 0.0
        m_currRMS = 0.0
        var i = m_size - m_delay
        while i >= 0 {
            if getRMS(index: i) > m_currRMS {
                m_currRMS = getRMS(index: i)
            }
            if getRMS(index: i) < low {
                break
            }
            m_currAUC += getRMS(index: i)
            i -= 1
        }
        i = m_size - m_delay + 1
        while i < m_size {
            if getRMS(index: i) > m_currRMS {
                m_currRMS = getRMS(index: i)
            }
            if getRMS(index: i) < low {
                break
            }
            m_currAUC += getRMS(index: i)
            i += 1
        }
    }

    private func pushBack(rms: Double, emg: Double) {
        m_bufRMS[m_ptr] = rms
        m_bufEMG[m_ptr] = emg
        m_ptr += 1
        if m_ptr == m_bufRMS.count {
            m_ptr = 0
        }
        m_have += 1
    }

    private func getRMS(index: Int) -> Double {
        let idx = (index + m_ptr) % m_bufRMS.count
        return m_bufRMS[idx]
    }

    private func getEMG(index: Int) -> Double {
        let idx = (index + m_ptr) % m_bufEMG.count
        return m_bufEMG[idx]
    }
}
