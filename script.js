document.addEventListener('DOMContentLoaded', () => {
    // Animate elements when they come into view
    const animateOnScroll = () => {
        const elements = document.querySelectorAll('.feature-card, .section-header, .download-card');
        const windowHeight = window.innerHeight;
        
        elements.forEach(element => {
            const elementPosition = element.getBoundingClientRect().top;
            
            if (elementPosition < windowHeight - 100) {
                element.style.opacity = '1';
                element.style.transform = 'translateY(0)';
            }
        });
    };
    
    // Initial check
    animateOnScroll();
    
    // Check on scroll
    window.addEventListener('scroll', animateOnScroll);
    
    // Screenshot carousel
    const carousel = () => {
        const screenshots = document.querySelectorAll('.screenshot');
        let currentIndex = 0;
        
        function showSlide(index) {
            screenshots.forEach(slide => slide.classList.remove('active'));
            screenshots[index].classList.add('active');
        }
        
        document.querySelector('.next-btn').addEventListener('click', () => {
            currentIndex = (currentIndex + 1) % screenshots.length;
            showSlide(currentIndex);
        });
        
        document.querySelector('.prev-btn').addEventListener('click', () => {
            currentIndex = (currentIndex - 1 + screenshots.length) % screenshots.length;
            showSlide(currentIndex);
        });
        
        // Auto-rotate every 5 seconds
        setInterval(() => {
            currentIndex = (currentIndex + 1) % screenshots.length;
            showSlide(currentIndex);
        }, 5000);
    };
    
    carousel();
    
    // Create dynamic particles
    const createParticles = () => {
        const particlesContainer = document.querySelector('.particles');
        const particleCount = 50;
        
        for (let i = 0; i < particleCount; i++) {
            const particle = document.createElement('div');
            particle.classList.add('particle');
            
            // Random properties
            const size = Math.random() * 5 + 1;
            const posX = Math.random() * 100;
            const posY = Math.random() * 100;
            const delay = Math.random() * 5;
            const duration = Math.random() * 10 + 5;
            
            particle.style.width = `${size}px`;
            particle.style.height = `${size}px`;
            particle.style.left = `${posX}%`;
            particle.style.top = `${posY}%`;
            particle.style.animationDelay = `${delay}s`;
            particle.style.animationDuration = `${duration}s`;
            particle.style.opacity = Math.random() * 0.5 + 0.1;
            
            particlesContainer.appendChild(particle);
        }
    };
    
    createParticles();
    
    // Button hover effects
    const buttons = document.querySelectorAll('.download-btn, .platform-btn');
    buttons.forEach(button => {
        button.addEventListener('mousemove', (e) => {
            const rect = button.getBoundingClientRect();
            const x = e.clientX - rect.left;
            const y = e.clientY - rect.top;
            
            button.style.setProperty('--mouse-x', `${x}px`);
            button.style.setProperty('--mouse-y', `${y}px`);
        });
    });
});
