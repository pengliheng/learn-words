package main

func indexOf(arr []string, val string) int {
	for i, v := range arr {
		if val == v {
			return i
		}
	}
	return -1
}
