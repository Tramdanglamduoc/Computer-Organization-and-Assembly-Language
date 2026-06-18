extern "C" int _stdcall ones_c(unsigned data, int n) {
	int res = 0;
	for (int i = 0; i < n; ++i) {
		if (data & 1) ++res;
		data = data >> 1;
	}
	return res;
}