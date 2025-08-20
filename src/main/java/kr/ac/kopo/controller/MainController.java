package kr.ac.kopo.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import kr.ac.kopo.service.RestaurantService;

@Controller
public class MainController {

    @Autowired
    private RestaurantService restaurantService;

    @GetMapping("/main.do")
    public String mainPage(Model model) {
        // 주간 랭킹 데이터 조회
        model.addAttribute("trendyRestaurants", restaurantService.getTrendyRestaurants());
        model.addAttribute("hotRestaurants", restaurantService.getHotRestaurants());
        model.addAttribute("steadyRestaurants", restaurantService.getSteadyRestaurants());
        
        return "index"; // /WEB-INF/jsp/index.jsp를 찾아 렌더링
    }
}
