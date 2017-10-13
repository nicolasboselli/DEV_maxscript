sel = selection as array
format "bakTM:%\n" sel[2].transform
format "localTM:%\n" sel[1].transform
format "bakTM rotationpart:%\n" sel[2].transform.rotationpart
format "localTM rotationpart:%\n" sel[1].transform.rotationpart
format "bakTM rotation:%\n" sel[2].rotation
format "localTM rotation:%\n" sel[1].rotation

format "decay1:%\n" (sel[1].rotation - sel[2].rotation)
format "decay2:%\n" (sel[1].transform.rotationpart - sel[2].transform.rotationpart)

