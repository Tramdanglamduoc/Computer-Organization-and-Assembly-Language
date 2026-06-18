int ones_c(unsigned data, int n) {
	int res = 0;
	for (int i = 0; i < n; ++i) {
		res += data & 1; 
		data >>= 1;
	}
	return res;
}