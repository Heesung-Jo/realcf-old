package com.controllers;

import java.util.*;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.net.*;
import java.io.*;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.Errors;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.security.core.context.SecurityContextHolder;
import com.auth.UserContext;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import org.springframework.web.servlet.ModelAndView;

import com.entity.member;
import com.service.memberService;
import com.service.xlmake;

import javax.validation.Valid;
import org.springframework.validation.BindingResult;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.service.memberService;

import com.entity.member;
//import com.service.UserContext;

import com.model.SignupForm;

import org.springframework.beans.factory.annotation.Autowired;
import java.io.UnsupportedEncodingException;



import com.except.WrongIdPasswordException;
import com.entity.coadata;
import com.entity.processdata;
import com.entity.teamdata;


import com.service.mywork;
import com.service.companywork;
import com.service.coaarray;
import org.springframework.security.oauth2.client.authentication.OAuth2AuthenticationToken;
@Controller
@RequestMapping
public class LoginController {
	
    private static final Logger logger = LoggerFactory
            .getLogger(LoginController.class);

	@Autowired
	private memberService memberservice;
	@Autowired
	private mywork mywork;
	
	
	
	@Autowired
	private companywork companywork;

	
    private final UserContext userContext;

	private final memberService memberService;
	
	/*
    private AuthService authService;
    
    public void setAuthService(AuthService authService) {
        this.authService = authService;
    }
   */

    @Autowired
    public LoginController(memberService memberService, UserContext userContext
    		) {
        if (userContext == null) {
            throw new IllegalArgumentException("userContext cannot be null");
        }
        if (memberService == null) {
            throw new IllegalArgumentException("memberService cannot be null");
        }
        this.userContext = userContext;
        this.memberService = memberService;
        
    }


	@GetMapping("/subwindow")
    public String getsubwindow(
    		Model model, HttpSession session, 
    		HttpServletResponse response) {
    	System.out.println("subwin");
         return "subwindow";
    }

    
 /*   
    @GetMapping("/thymeleaf/login")
    public String form(LoginCommand loginCommand) {
    	System.out.println(123);
    	System.out.println(1239090);
        //@PathVariable("name") String name
    	return "thymeleaf/login";
    }
*/
    @GetMapping("/thymeleaf/login")
    public ModelAndView login(
            @RequestParam(value = "error", required = false) String error,
            @RequestParam(value = "logout", required = false) String logout) {

        logger.info("******login(error): {} ***************************************", error);
        logger.info("******login(logout): {} ***************************************", logout);

        ModelAndView model = new ModelAndView();
        if (error != null) {
            model.addObject("error", "Invalid username and password!");
        }

        if (logout != null) {
            model.addObject("message", "You've been logged out successfully.");
        }
        model.setViewName("thymeleaf/login");

        return model;

    }

    
    @GetMapping("/view/second")
    public String second(Model model, HttpSession httpSession) {
    	System.out.println("why why why");
    	member member = userContext.getCurrentUser();
    	
    	System.out.println(member.getEmail());
    	System.out.println(member.getname());
 
    	
      return "search";
    }
    @GetMapping("/view/search")
    public String search(Model model) {
    	System.out.println("why why why");
      return "search";
    }

    
    
    
    @GetMapping("/view/home")
    public String home(Model model) {
    	
      return "start";
    }

    @GetMapping("/view/explanation")
    public String explanation(Model mav) {

    	System.out.println(8989898);
    	SecurityContextHolder.getContext().setAuthentication(null);
    	
    	/* ?????????????????? ????????? ????????? ??????????????? ????????? ???????????????, ????????? ????????? ????????? ??? ???????????????
    	      ??????, ?????????????????? ???????????? ????????? ?????? ?????????, ?????????
		String url = "http://localhost:5000";
		String sb = "";
		try {
			
		  // post ?????? //?????? ?????? ????????? ?????????	
	        Map<String,Object> params = new LinkedHashMap<>(); // ???????????? ??????
	        params.put("name", "james");
	        params.put("email", "james@example.com");
	        params.put("reply_to_thread", 10394);
	        params.put("message", "Hello World");
	 
	        StringBuilder postData = new StringBuilder();
	        for(Map.Entry<String,Object> param : params.entrySet()) {
	            if(postData.length() != 0) postData.append('&');
	            postData.append(URLEncoder.encode(param.getKey(), "UTF-8"));
	            postData.append('=');
	            postData.append(URLEncoder.encode(String.valueOf(param.getValue()), "UTF-8"));
	        }
	        byte[] postDataBytes = postData.toString().getBytes("UTF-8");
	 
	        HttpURLConnection conn = (HttpURLConnection) new URL(url).openConnection();
	        conn.setRequestMethod("POST");
	        conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
	        conn.setRequestProperty("Content-Length", String.valueOf(postDataBytes.length));
	        conn.setDoOutput(true);
	        conn.getOutputStream().write(postDataBytes); // POST ??????

	        */
	        
       /* get??????			
			HttpURLConnection conn = (HttpURLConnection) new URL(url).openConnection();
       */
			
   /*
			BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "utf-8"));

			String line = null;

			while ((line = br.readLine()) != null) {
				sb = sb + line + "\n";
			}
			System.out.println("========br======" + sb.toString());
			if (sb.toString().contains("ok")) {
				System.out.println("test");
				
			}
			br.close();
           
			System.out.println("" + sb.toString());
		} catch (MalformedURLException e) {
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		mav.addAttribute("test", sb.toString()); // "test1"??? jsp???????????? ????????? ??????, 
        						//sb.toString??? value???(???????????? test)
    	
      */
    	
      return "explanation";
    }

    @GetMapping("/view/gojs")
    public String gojs(Model model) {
      return "gojs";
    }
    
    @GetMapping("/view/gojs9")
    public String gojs5(Model model) {
      
    	
      System.out.println("????????? ??????");
      System.out.println("????????? ??????");
      
      return "gojs9";
    }


    
    
    // ????????? ???????????? ????????? ?????? ?????? ??? ???????????? ???
    @RequestMapping("/view/start")
    public String Scoping(Model model) {

     	
    	return "start";
    }
    
    
    
    @PostMapping("/register/login")
    public String submit(
    		LoginCommand loginCommand, Errors errors, HttpSession session,
    		HttpServletResponse response) {
    	
    	System.out.println(123);
    	System.out.println(loginCommand.getusername());
    	System.out.println(errors);
    	
        if (errors.hasErrors()) {
            return "login/loginForm";
        } 
        try {
        	
        	/* NoSuchPageException
            Member auth = authService.authenticate( loginCommand.getusername(),
                    loginCommand.getPassword());
            System.out.println("123123123");
            session.setAttribute("authInfo", auth);
            */

            return "survey/surveyForm";
        } catch (WrongIdPasswordException e) {
            errors.reject("idPasswordNotMatching");
            return "register/loginForm";
        }
    }

    @PostMapping("/view/processsubmit")
    public String processsubmit(
    		@RequestParam Map<String, String> data, HttpSession session,
    		HttpServletRequest request, HttpServletResponse response) 
            throws UnsupportedEncodingException {

      	request.setCharacterEncoding("UTF-8");
      	//response.setContentType("text/html;charset=UTF-8");

        // ????????? ????????? ????????? ????????? ????????? ???????????? ?????? ????????? ???
      	
     	
      	// ????????? ????????? ????????????
    	for(String pro : data.keySet()) {
    		System.out.println(pro);
        	
    		// table ???????????? ???????????? ????????? ???????????????, process???_hidden, process???_???????????? ????????? ?????? ?????? ????????? ?????? ????????????
    		// ????????? process?????? ???????????? ????????? ????????? ??????
    		if(pro.contains("_hidden") != true) {
        		// ???????????? ??????
        		processdata process = new processdata();
            	process.setname(pro);
              
            	// ??? ??????
        		String[] arrayParam = request.getParameterValues(pro);
              	for (int i = 0; i < arrayParam.length; i++) {
              		
              		teamdata team = new teamdata();
              		team.setname(arrayParam[i]);
              	    process.addteamdata(team);
              	}
              	
              	// coa ??????
              	coadata coa = new coadata();
              	coa.setname(request.getParameter(pro + "_hidden"));

      		}
        	
    	}

    	
    	// ?????? ?????? ????????? ????????????
    	return "inputsuccess";
    }	
    
    
    @RequestMapping("/view/loginSuccess")
    public String submit2(Model model, OAuth2AuthenticationToken authentication) {
        System.out.println("authentication = " + authentication);
        
        
    	return "loginsuccess";
    }
    
    @RequestMapping("/register/realform")
    public String signup(@ModelAttribute SignupForm signupForm) {
        return "realform";
    }
 
    
    @RequestMapping(value="/register/realform", method=RequestMethod.POST)
    public String signup(@ModelAttribute @Valid SignupForm signupForm, BindingResult result
    		, RedirectAttributes redirectAttributes
    ) {
        if(result.hasErrors()) {
        	System.out.println("error??? ????????????");
            return "realform";
        }

        String email = signupForm.getEmail();
        System.out.println(email);
        
        /*
        if(memberservice.findUserByEmail(email) != null) {
            result.rejectValue("email", "errors.signup.email", "Email address is already in use.");
            return "realform";
        }
*/
        
        member user = new member();
        user.setEmail(email);
        user.setname(signupForm.getname());
        user.setPassword("{noop}" + signupForm.getPassword());

     //   logger.info("CalendarUser: {}", user);

        System.out.println("????????? ?????????");
        int id = memberservice.createUser(user);
        user.setId(id);
      //  userContext.setCurrentUser(user);
        System.out.println("????????? ?????????");
        redirectAttributes.addFlashAttribute("message", "You have successfully signed up and logged in.");
        return "redirect:/view/Scoping";
    }
    
    
    
    
}
