Ems Shipping
===============

This is a Spree extension that wraps EMS Russian Post shipping.

Расширение Ems Shipping добавляет к платформе Spree калькулятор доставки товаров по России службой EMS Russian Post (на данный момент реализован только калькулятор для доставки внутри России, для интернациональной доставки необходимо реализовывать отдельный калькулятор).
После установки расширения Ems Shipping в системе появляется новый калькулятор EMS in Russia, который можно использовать для создания методов доставки.

Для определения доступности доставки и стоимости калькулятор использует EMS Russian Post API (на данный момент считается, что калькулятор будет использоваться только для создания методов доставки по России, т.к. калькулятор при определениии доступности доставки не проверяет страну).  

Config
---
Ems Shipping имеет следующие настройки

<pre>
Spree::EmsShipping::Config[:api_url] - задает URL веб-сервиса EMS Russian Post API
Spree::EmsShipping::Config[:origin_city] - задает город от которого будет считаться доставка
Spree::EmsShipping::Config[:weight_if_nil] - задает вес (в граммах) который будет использоваться в случае если у товара отсутствует вес. Так как для доставки через EMS вес является обязательным парпметром, то в случае если хотя бы у одного товара в заказе вес будет нулевой данный метод доставки не будет доступен для заказа.
</pre>

Данные параметры со значениями по умолчанию будут доступны после инсталирования расширения в config/initializers/spree_ems_shipping.rb

Installation
------------

1. Add the following to your applications Gemfile

    gem 'spree_ems_shipping'

2. Run bundler

    bundle install

3. Run install generator
   
   rails g spree_ems_shipping:install




Further Reading
---------------

Andrea Singh has also written an excellent [blog post](http://blog.madebydna.com/all/code/2010/05/26/setting-up-usps-shipping-with-spree.html) covering the use of this extension in detail.