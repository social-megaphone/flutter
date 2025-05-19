'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter_bootstrap.js": "5aa7e02c0692e2b1182839cc31781474",
"version.json": "947e4aa3376ba0f2980943cc74e277d4",
"index.html": "986ad5c93a4d29ee8c66cb95f4d114a6",
"/": "986ad5c93a4d29ee8c66cb95f4d114a6",
"main.dart.js": "41f14ff158d13414d7771da302fc649b",
"flutter.js": "76f08d47ff9f5715220992f993002504",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"manifest.json": "485702f242616683614cf422693e84f9",
"assets/AssetManifest.json": "ca4fe08528b2e906e56d2859569f7956",
"assets/NOTICES": "6bd7c6966b7cb019f76fb3e534f6c8db",
"assets/FontManifest.json": "739ccc4903ed54ac1774f5ba39807047",
"assets/AssetManifest.bin.json": "f2e39dee026e474f7a26ccecdae38817",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin": "a12acc79c83d6b1e41ce5ae040bf1e40",
"assets/fonts/MaterialIcons-Regular.otf": "23a6619ac9cb81ee26aad0f8c0e12dcf",
"assets/assets/images/bottom_nav_icon/profile_icon.png": "afe8d653984dff9e2c0eaf8e5584df9a",
"assets/assets/images/bottom_nav_icon/lounge_icon.png": "6372840cbca1b4b6e9184e31a44156f2",
"assets/assets/images/bottom_nav_icon/routine_add_icon.png": "14232d357616f3757f7c928fb8d769b0",
"assets/assets/images/bottom_nav_icon/badge_icon.png": "5be3205194cab58e0a90cdfb94e6e915",
"assets/assets/images/bottom_nav_icon/save_icon.png": "aa4329e32f96374d93918277c4570299",
"assets/assets/images/petal.png": "225398a0fc217807d9cdfc6332f8c4ee",
"assets/assets/images/profile_background_temp.png": "a6c36d6e31d071ac4b470e2daaead37d",
"assets/assets/images/post_like_emojies/like_emoji_empower.png": "5019ad0d0664297b711088d33bd06645",
"assets/assets/images/post_like_emojies/like_emoji_love.png": "f899e3d996b66828bc1c2b578eef9528",
"assets/assets/images/post_like_emojies/like_emoji_thumbsup.png": "6f768747f3b7d454dba5589b16b3dda6",
"assets/assets/images/post_like_emojies/like_emoji_sad.png": "a742e729825e15bfe86cc9a29104fcac",
"assets/assets/images/post_like_emojies/like_emoji_surprised.png": "5bde78340fd23928f212dc6da2809621",
"assets/assets/images/badge_example.png": "072d5d6a1c227a2e0135536160737c34",
"assets/assets/images/profile_image_temp.png": "e5da84308871c30aa6d3d5b607c84bb9",
"assets/assets/images/background_onboarding_screen.png": "88446df3a144ebc78fb67fc9dacf7ca5",
"assets/assets/images/character_without_cushion.png": "6a0c8d946c544d42d569e57fbb4a9766",
"assets/assets/images/suggested_routine/drink_water.png": "30f619f46a05187bdfed0a4b0e392512",
"assets/assets/images/suggested_routine/personal_development/three.png": "c4546d44aeceb56d619e37e2a0c1eb1f",
"assets/assets/images/suggested_routine/personal_development/six.png": "364c330b9c1d2992b894d13dca1f7575",
"assets/assets/images/suggested_routine/personal_development/two.png": "26437a021d94c57600ecfa6249990e60",
"assets/assets/images/suggested_routine/personal_development/four.png": "9c0a15e2e202e5aef1db6a31730b4c23",
"assets/assets/images/suggested_routine/personal_development/five.png": "7ae656b0012edc4503a01a7fab106535",
"assets/assets/images/suggested_routine/personal_development/one.png": "0cce8f9ec19920fbe9f0d72ecead468c",
"assets/assets/images/suggested_routine/slow_food.png": "e1cec36fb91cb075a1a36ec4739b129a",
"assets/assets/images/suggested_routine/get_rid_of.png": "cf0fe9fbcd7eddcb17df6559f3885cf9",
"assets/assets/images/suggested_routine/life_habit/three.png": "ffdb28ad16273e096c97a2933eb77d3f",
"assets/assets/images/suggested_routine/life_habit/six.png": "cdcee8435f801910add329637211a3c5",
"assets/assets/images/suggested_routine/life_habit/two.png": "3eff2673b705c2bb1df43c6cd1924d64",
"assets/assets/images/suggested_routine/life_habit/four.png": "e5dbdef0ae2779ad60b018721d7d1778",
"assets/assets/images/suggested_routine/life_habit/five.png": "969dfdc758d3ea08fe82676f905e4770",
"assets/assets/images/suggested_routine/life_habit/one.png": "9c632ae4047ec37d97dce388935f5382",
"assets/assets/images/suggested_routine/stretch.png": "1dd4baf93343083296a20a3759acb759",
"assets/assets/images/suggested_routine/human_relationship/three.png": "a7a1cc1ab16e4543ca631d2ede8f22ee",
"assets/assets/images/suggested_routine/human_relationship/six.png": "e5d0f98b624d35aa2c427bb0f2432b6d",
"assets/assets/images/suggested_routine/human_relationship/two.png": "afab514c86ac99bc7faa04adef987329",
"assets/assets/images/suggested_routine/human_relationship/four.png": "f8d6359fa2b3bb001546a628514845c8",
"assets/assets/images/suggested_routine/human_relationship/five.png": "434fedf6dd6619863693e878c2f735e6",
"assets/assets/images/suggested_routine/human_relationship/one.png": "fab6a1ebbd6f79fc96245dcfd3772338",
"assets/assets/images/suggested_routine/windy_walk.png": "0d8c9b398c3132a3e56f7bc9eba8c149",
"assets/assets/images/suggested_routine/emotion_control/three.png": "b2ed03f07da02d80aee4404afbdbc9cb",
"assets/assets/images/suggested_routine/emotion_control/six.png": "60740df2f79f383bdbcf2238d82319f3",
"assets/assets/images/suggested_routine/emotion_control/two.png": "e5025bfb39aa5665f03da76c334a7b35",
"assets/assets/images/suggested_routine/emotion_control/four.png": "89916efd38446ac627a879f2706993c9",
"assets/assets/images/suggested_routine/emotion_control/five.png": "78735ff8e4d1a7fe6f86607efbed41ee",
"assets/assets/images/suggested_routine/emotion_control/one.png": "0e35cd8fd09dad3ef4bd6b3d10528c9c",
"assets/assets/images/suggested_routine/small_trial/three.png": "6afa83711d81e354e292b020dfd06ab5",
"assets/assets/images/suggested_routine/small_trial/two.png": "34aa60883d8e57eb0a652512e62879b9",
"assets/assets/images/suggested_routine/small_trial/four.png": "9a2787f64a610b379e7a1b309790d36d",
"assets/assets/images/suggested_routine/small_trial/one.png": "c371acf1edacf5083905d35751aef570",
"assets/assets/images/character_with_cushion.png": "d81d9fbda3f66a88b935123c9e768142",
"assets/assets/images/routine_explanation_water.png": "0366eee980133916d71c57a827924612",
"assets/assets/images/badge_map/badge_map_level_three.png": "e76825ddd9452296b4c8821310ee2627",
"assets/assets/images/badge_map/badge_map_level_two.png": "5a283165a64bbe6c38c817159c45ec05",
"assets/assets/images/badge_map/badge_map_h.png": "b6ac648e4438ec10381e2dc0b3ae4211",
"assets/assets/images/badge_map/badge_map_milestone.png": "37cf2128132d3c48915cdd0c07caf98a",
"assets/assets/images/badge_map/badge_map_c.png": "ffacded9a67153daea2a89789df72514",
"assets/assets/images/badge_map/badge_map_b.png": "16a78ddac61281748e0bdae811855eea",
"assets/assets/images/badge_map/badge_map_level_one.png": "4c48f93803df05a46ec46c720e896a85",
"assets/assets/images/badge_map/badge_map_a.png": "eb907c0904f1156013b693ac4df46c8e",
"assets/assets/images/badge_map/badge_map_e.png": "68e2269daf5d6a0381afac281debcbc4",
"assets/assets/images/badge_map/badge_map_d.png": "4d9198a07379b6947d0bc21aae60994d",
"assets/assets/images/badge_map/badge_map_f.png": "1b91e9c8795d627a47b2f09c4542c8c8",
"assets/assets/images/badge_map/badge_map_g.png": "b36f8b2285aecbc7eeef59037ef1f7a8",
"assets/assets/fonts/Pretendard/Pretendard-Medium.ttf": "6d045f83b15a4ce0108df8e96e53851e",
"assets/assets/fonts/Pretendard/Pretendard-Black.ttf": "15c7d1db3ba3f775e8c48e40f2744c2b",
"assets/assets/fonts/Pretendard/Pretendard-Regular.ttf": "f9574625d71019a3d7d8417e9ac35e7e",
"assets/assets/fonts/Pretendard/Pretendard-Thin.ttf": "1d54880fd193ab9ef9364c48ff968d63",
"assets/assets/fonts/Pretendard/Pretendard-ExtraLight.ttf": "27cb5c5e9993269e199efb199e24b244",
"assets/assets/fonts/Pretendard/Pretendard-SemiBold.ttf": "52e17b18a3a47c23bcdd626a3d8f163c",
"assets/assets/fonts/Pretendard/Pretendard-ExtraBold.ttf": "2101fb53456d23d685a5172792599214",
"assets/assets/fonts/Pretendard/Pretendard-Bold.ttf": "0e31c423b3971eecd79d2866b8ad65ac",
"assets/assets/fonts/Pretendard/Pretendard-Light.ttf": "1a9b52d0674840d80e8a60dd1270114f",
"assets/assets/fonts/AppleSDGothicNeo/AppleSDGothicNeoH.ttf": "ee2dab186809a3df292bd2297739c6c3",
"assets/assets/fonts/AppleSDGothicNeo/AppleSDGothicNeoM.ttf": "3a44ffb1539dbcfce07e73ce69ea55de",
"assets/assets/fonts/AppleSDGothicNeo/AppleSDGothicNeoL.ttf": "b07ac29c8c063198e384a69bfe91c975",
"assets/assets/fonts/AppleSDGothicNeo/AppleSDGothicNeoSB.ttf": "8683b84b58121f0dc4070ed892d02614",
"assets/assets/fonts/AppleSDGothicNeo/AppleSDGothicNeoEB.ttf": "eaafc4677b0f252b3404c5268e0eb26d",
"assets/assets/fonts/AppleSDGothicNeo/AppleSDGothicNeoUL.ttf": "fa20f8e0f9a1cce5284e24efbc1e6d14",
"assets/assets/fonts/AppleSDGothicNeo/AppleSDGothicNeoB.ttf": "018066fbccbce3cc4bbba5d3ac4f1033",
"assets/assets/fonts/AppleSDGothicNeo/AppleSDGothicNeoT.ttf": "c86faaf0dfc0eecd7d3fb29a684f9706",
"assets/assets/fonts/AppleSDGothicNeo/AppleSDGothicNeoR.ttf": "85ba110e6b8d4c2e961f21ef648d27ea",
"assets/assets/fonts/NotoSansKR/NotoSansKR-Light.ttf": "e61301e66b058697c6031c39edb7c0d2",
"assets/assets/fonts/NotoSansKR/NotoSansKR-Medium.ttf": "4dee649c78a37741c4f5d9fdb69ea434",
"assets/assets/fonts/NotoSansKR/NotoSansKR-ExtraBold.ttf": "db13746e4342665b3fb5571c353f8c46",
"assets/assets/fonts/NotoSansKR/NotoSansKR-Regular.ttf": "e910afbd441c5247227fb4a731d65799",
"assets/assets/fonts/NotoSansKR/NotoSansKR-Semibold.ttf": "90c2026b48704ad2560e68249b15b7f5",
"assets/assets/fonts/NotoSansKR/NotoSansKR-Black.ttf": "15e2e9d1b8e380eafc51a606a7e671d6",
"assets/assets/fonts/NotoSansKR/NotoSansKR-Thin.ttf": "b59719d81a60f284b7c372c7891689fd",
"assets/assets/fonts/NotoSansKR/NotoSansKR-ExtraLight.ttf": "33e4ba0602de9a23075c13d344127395",
"assets/assets/fonts/NotoSansKR/NotoSansKR-Bold.ttf": "671db5f821991c90d7f8499bcf9fed7e",
"canvaskit/skwasm_st.js": "d1326ceef381ad382ab492ba5d96f04d",
"canvaskit/skwasm.js": "f2ad9363618c5f62e813740099a80e63",
"canvaskit/skwasm.js.symbols": "80806576fa1056b43dd6d0b445b4b6f7",
"canvaskit/canvaskit.js.symbols": "68eb703b9a609baef8ee0e413b442f33",
"canvaskit/skwasm.wasm": "f0dfd99007f989368db17c9abeed5a49",
"canvaskit/chromium/canvaskit.js.symbols": "5a23598a2a8efd18ec3b60de5d28af8f",
"canvaskit/chromium/canvaskit.js": "34beda9f39eb7d992d46125ca868dc61",
"canvaskit/chromium/canvaskit.wasm": "64a386c87532ae52ae041d18a32a3635",
"canvaskit/skwasm_st.js.symbols": "c7e7aac7cd8b612defd62b43e3050bdd",
"canvaskit/canvaskit.js": "86e461cf471c1640fd2b461ece4589df",
"canvaskit/canvaskit.wasm": "efeeba7dcc952dae57870d4df3111fad",
"canvaskit/skwasm_st.wasm": "56c3973560dfcbf28ce47cebe40f3206"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
