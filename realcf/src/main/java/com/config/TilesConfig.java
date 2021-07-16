package com.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.view.tiles3.TilesConfigurer;
import org.springframework.web.servlet.view.tiles3.TilesView;
import org.springframework.web.servlet.view.tiles3.TilesViewResolver;
import org.springframework.web.servlet.view.UrlBasedViewResolver;
import org.springframework.web.servlet.ViewResolver;
import org.springframework.web.servlet.view.InternalResourceViewResolver;
/**
* Created by kmbaek on 2016-10-13.
*/
@Configuration
public class TilesConfig {
/**
* Initialise Tiles on application startup and identify the location of the tiles configuration file, tiles.xml.
*
* @return tiles configurer
*/
@Bean
public TilesConfigurer tilesConfigurer() {

final TilesConfigurer configurer = new TilesConfigurer();
configurer.setDefinitions(new String[] {
        "/WEB-INF/layout/tiles.xml",
        "/WEB-INF/views/**/tiles.xml"
		});
configurer.setCheckRefresh(true);
return configurer;
}

/**
* Introduce a Tiles view resolver, this is a convenience implementation that extends URLBasedViewResolver.
*
* @return tiles view resolver
*/
@Bean
public ViewResolver viewResolver() {
	  UrlBasedViewResolver viewResolver = new UrlBasedViewResolver();
	  viewResolver.setViewClass(TilesView.class);
	  // 순번을 살리면 에러남
	  //viewResolver.setOrder(1);
    return viewResolver;
}
@Bean
public InternalResourceViewResolver InternalviewResolver() {
	  InternalResourceViewResolver templateResolver = new InternalResourceViewResolver();
	    templateResolver.setPrefix("/WEB-INF/view/");
	    templateResolver.setSuffix(".jsp");
	    //templateResolver.setOrder(2);
    return templateResolver;
}  

}