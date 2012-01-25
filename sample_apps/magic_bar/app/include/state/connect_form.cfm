<cfprocessingdirective pageEncoding="utf-8" /><cfoutput>
		<form action="/form/partner" method="post" accept-charset="utf-8" id="partnerForm">
			<h2 class="prepend-5 bottom formShow">Условия</h2>
			<div class="clear"></div>
			<ol id="rulesList" class="prepend-5 span-14 formShow">
				<li>Никто ни&nbsp;принимает на&nbsp;себя никаких обязательств и&nbsp;все действуют на&nbsp;свой страх и&nbsp;риск.</li>
				<li>Партнер вправе удалить MagicBar со&nbsp;своего сайта в&nbsp;любой момент без уведомления кого-либо.</li>
				<li>MagicBar вправе удалить ссылку партнера в&nbsp;любой момент без уведомления кого-либо, как автоматически, в&nbsp;случае отсутствия событий в&nbsp;логах MagicBar, так и&nbsp;вручную по&nbsp;решению администрации MagicBar.</li>
				<li>На&nbsp;получение статуса партнера могут рассчитывать только владельцы ресурсов региональной направленности (Форум города&nbsp;Н, новости города Н).</li>
				<li>Администрация MagicBar вправе проигнорировать те&nbsp;заявки, чьи авторы проигнорировали пункт &##8470;&nbsp;4&nbsp;на этой странице.</li>
			</ol>
			<div class="clear"></div>
			<div class="formHide hide">
				<div class="row">
					<div class="span-5 grey labelLeft">
						<label for="name">Ваше имя</label>
					</div>
					<div class="span-14" id="vName">
						<input type="text" name="name" id="name" class="span-14" />
						<div class="clear"></div>
						<div class="validation italic">
							<label for="name">
								<span class="helper">Желательно полное</span>
								<span class="textfieldRequiredMsg">Представьтесь пожалуйста</span>
								<span class="textfieldMaxCharsMsg">Имя слишком длинное</span>
							</label>
						</div>
					</div>
					<div class="clear"></div>
				</div>
				<div class="row">
					<div class="span-5 grey labelLeft">
						<label for="url">Адрес сайта</label>
					</div>
					<div class="span-14" id="vUrl">
						<input type="text" name="url" id="url" class="span-14" value="http://" />
						<div class="clear"></div>
						<div class="validation italic">
							<div class="helper">
							</div>
							<label for="url">
								<span class="helper">
									<span class="grey">Например: </span>
									http://www.mysite.ru
									<span class="grey">— наличие собственного домена обязательно</span>
								</span>
								<span class="textfieldRequiredMsg">Укажите адрес сайта</span>
								<span class="textfieldInvalidFormatMsg">Недопустимый формат ссылки</span>
							</label>
						</div>
					</div>
					<div class="clear"></div>
				</div>
				<div class="row">
					<div class="span-5 grey labelLeft">
						<label for="label">Название ссылки</label>
					</div>
					<div class="span-5" id="vLabel">
						<input type="text" name="label" id="label" class="span-5" />
						<div class="clear"></div>
						<div class="validation italic">
							<label for="label">
								<span class="helper">
									<span class="grey">Например:</span> Форум
								</span>
								<span class="textfieldRequiredMsg">Укажите название ссылки</span>
								<span class="textfieldMaxCharsMsg">Название слишком длинное</span>
							</label>
						</div>
					</div>
					<div class="span-4 grey labelLeft">
						<label for="locationLabel">Ваш город</label>
					</div>
					<div class="span-5" id="vLocation">
						<input type="text" name="locationLabel" id="locationLabel" class="span-5" />
						<input type="hidden" name="locationRoute" id="locationRoute" />
						<div class="clear"></div>
						<div class="validation italic">
							<label for="locationLabel" class="grey">
								<span class="helper">
									Например: <a href="route" class="red local" id="locationSuggest">Москва</a>
								</span>
								<span class="textfieldRequiredMsg">Укажите город</span>
								<span class="textfieldCustomMsg">Недопустимое название города</span>
							</label>
						</div>
						
					</div>
					<div class="clear"></div>
				</div>
				<div class="row">
					<div class="span-5 grey labelLeft">
						<label for="email">@ почта</label>
					</div>
					<div class="span-5" id="vEmail">
						<input type="text" name="email" id="email" class="span-5" />
						<div class="clear"></div>
						<div class="validation italic">
							<label for="email">
								<span class="helper">Сюда придут инструкции</span>
								<span class="textfieldRequiredMsg">Укажите ваш e-mail</span>
								<span class="textfieldInvalidFormatMsg">E-mail указан некорректно</span>
							</label>
						</div>
					</div>
					<div class="span-4 grey labelLeft">
						<label for="phone">Телефон</label>
					</div>
					<div class="span-5" id="vPhone">
						<input type="text" name="phone" id="phone" class="span-5" />
						<div class="clear"></div>
						<div class="validation italic">
							<label for="phone">
								<span class="helper"><span class="grey">Например:</span> +7 123 456-78-90</span>
								<span class="textfieldRequiredMsg">Укажите телефонный номер</span>
								<span class="textfieldInvalidFormatMsg">Телефонный номер указан некорректно</span>
							</label>
						</div>
					</div>
					<div class="clear"></div>
				</div>
				<br/>
			</div>
			<div class="prepend-5">
				<input type="checkbox" name="rules" value="1" id="rules" />
				<label for="rules" class="local">Я принимаю условия</label>
			</div>
			<div class="prepend-5 formHide hide">
				<br/><br/>
				<input type="submit" name="submit" value="Отправить заявку" />
			</div>
		</form>
	<div class="clear"></div>
</cfoutput>
<script type="text/javascript" charset="utf-8">//<![CDATA[
	var vLabel = new Spry.Widget.ValidationTextField("vLabel", "none", {
		validateOn:['blur'],
		isRequired:true,
		maxChars: 15
	});
	var vLocation = new Spry.Widget.ValidationTextField("vLocation", "none", {
		validateOn:['blur'],
		isRequired:true
	});
	var vUrl = new Spry.Widget.ValidationTextField("vUrl", "url", {
		validateOn:['blur']
	});
	var vName = new Spry.Widget.ValidationTextField("vName", "none", {
		validateOn:['blur'],
		maxChars: 50
	});
	var vEmail = new Spry.Widget.ValidationTextField("vEmail", "email", {
		validateOn:['blur']
	});
	var vPhone = new Spry.Widget.ValidationTextField("vPhone", "none", {
		validateOn:['blur'],
		validation: function (v){
			var v = v.replace(/\D/g,'');
			return v.length >= 11;
		}
	});
//]]></script>