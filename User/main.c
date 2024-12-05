#include "stm32f4xx.h"
#include "stm32f4xx_gpio.h"
#include "stm32f4xx_rcc.h"

void Delay(__IO uint32_t nCount);

int main(void)
{
    GPIO_InitTypeDef  GPIO_InitStructure;

    // 使能GPIOA时钟
    RCC_AHB1PeriphClockCmd(RCC_AHB1Periph_GPIOA, ENABLE);

    // 配置PA5为输出模式
    GPIO_InitStructure.GPIO_Pin = GPIO_Pin_5;
    GPIO_InitStructure.GPIO_Mode = GPIO_Mode_OUT;
    GPIO_InitStructure.GPIO_OType = GPIO_OType_PP;
    GPIO_InitStructure.GPIO_PuPd = GPIO_PuPd_NOPULL;
    GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;
    GPIO_Init(GPIOA, &GPIO_InitStructure);

    while (1)
    {
        // 切换PA5引脚状态
        GPIO_ToggleBits(GPIOA, GPIO_Pin_5);

        // 延时
        Delay(0x3FFFFF);
    }
}

void Delay(__IO uint32_t nCount)
{
    while(nCount--)
    {
    }
}

//暂时性实现
volatile uint32_t TimingDelay = 0;
void TimingDelay_Decrement(void) {
    if (TimingDelay > 0) {
        TimingDelay--;
    }
}