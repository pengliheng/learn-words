package com.github.pengliheng.sprintboot1.controller;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;


@RestController
public class HelloWorldController {


    private static int count = 0;
    private static HelloWorldController reentrantLock = new HelloWorldController();
    static class MyThread extends Thread{

        @Override
        public void run() {
            super.run();
            try {
                while (true){
                    boolean result = reentrantLock.tryLock();
                    if (result){
                        System.out.println(Thread.currentThread().getName() + "get the lock success and run the syn code " + count ++);
                        reentrantLock.unlock();
                    }else{
                        System.out.println(Thread.currentThread().getName() + "get the lock failed and run the syn code " + count);
                    }
                    System.out.println(Thread.currentThread().getName() + "run the asyntronized code  " + count);
                    Thread.sleep(500);
                }

            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
    }

    @RequestMapping("/hello")
    public String index() {

        return "Hello World";
    }
}