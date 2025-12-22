// Synchronized video playback for grouped videos
// This script synchronizes playback of videos within the same group

(function() {
    'use strict';
    
    // Initialize when DOM is ready
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', initSyncVideos);
    } else {
        initSyncVideos();
    }
    
    function initSyncVideos() {
        // Find all video groups
        const videoGroups = document.querySelectorAll('.video-group');
        
        videoGroups.forEach(function(group) {
            const videos = group.querySelectorAll('video');
            
            if (videos.length === 0) return;
            
            // Synchronize play/pause
            videos.forEach(function(video) {
                video.addEventListener('play', function() {
                    syncPlay(videos, video);
                });
                
                video.addEventListener('pause', function() {
                    syncPause(videos, video);
                });
                
                video.addEventListener('seeked', function() {
                    syncSeek(videos, video);
                });
                
                video.addEventListener('timeupdate', function() {
                    syncTime(videos, video);
                });
            });
        });
    }
    
    let isSyncing = false;
    
    function syncPlay(videos, sourceVideo) {
        if (isSyncing) return;
        isSyncing = true;
        
        videos.forEach(function(video) {
            if (video !== sourceVideo && video.paused) {
                video.play().catch(function(e) {
                    console.log('Video play failed:', e);
                });
            }
        });
        
        isSyncing = false;
    }
    
    function syncPause(videos, sourceVideo) {
        if (isSyncing) return;
        isSyncing = true;
        
        videos.forEach(function(video) {
            if (video !== sourceVideo && !video.paused) {
                video.pause();
            }
        });
        
        isSyncing = false;
    }
    
    function syncSeek(videos, sourceVideo) {
        if (isSyncing) return;
        isSyncing = true;
        
        const currentTime = sourceVideo.currentTime;
        videos.forEach(function(video) {
            if (video !== sourceVideo && Math.abs(video.currentTime - currentTime) > 0.1) {
                video.currentTime = currentTime;
            }
        });
        
        isSyncing = false;
    }
    
    function syncTime(videos, sourceVideo) {
        if (isSyncing) return;
        
        // Only sync if there's a significant drift (>0.2 seconds)
        videos.forEach(function(video) {
            if (video !== sourceVideo && !video.paused) {
                const timeDiff = Math.abs(video.currentTime - sourceVideo.currentTime);
                if (timeDiff > 0.2) {
                    isSyncing = true;
                    video.currentTime = sourceVideo.currentTime;
                    isSyncing = false;
                }
            }
        });
    }
})();
