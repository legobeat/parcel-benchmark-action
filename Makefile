github/three:
	mkdir -p github
	git clone --depth 1 --branch r108 https://github.com/mrdoob/three.js.git github/three

benchmarks/three: | github/three
	mkdir -p benchmarks/three
	echo > benchmarks/three/entry.js
	echo '{ "extends": "@parcel/config-default", "reporters": ["...", "@parcel/reporter-build-metrics"] }' >> benchmarks/three/.parcelrc
	echo '{ "name": "@parcel/three-js-benchmark", "version": "1.0.0", "source": "entry.js", "license": "MIT", "devDependencies": { "@parcel/reporter-build-metrics": "^2.0.0-alpha.3.1", "@parcel/config-default": "^2.0.0-alpha.3.1" } }' >> benchmarks/three/package.json
	for i in 1 2 3 4; do test -d "benchmarks/three/copy$$i" || cp -r github/three/src "benchmarks/three/copy$$i"; done
	for i in 1 2 3 4; do echo "import * as copy$$i from './copy$$i/Three.js'; export {copy$$i}" >> benchmarks/three/entry.js; done
	echo 'Line count:' && find benchmarks/three -name '*.js' | xargs wc -l | tail -n 1
	